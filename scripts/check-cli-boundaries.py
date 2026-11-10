"""Exercise Han CLI I/O, exit status and SIGINT using a saved executable."""

import argparse
from contextlib import contextmanager
import os
from pathlib import Path
import select
import shutil
import signal
import subprocess
import tempfile
import time


@contextmanager
def broken_pipe():
    reader, writer = os.pipe()
    os.close(reader)
    with os.fdopen(writer, "wb") as pipe:
        yield pipe


def run_case(binary, mode, *, stdout=subprocess.PIPE, stderr=subprocess.PIPE):
    return subprocess.run([binary], env=dict(os.environ, HAN_CLI_CASE=mode),
                          stdin=subprocess.DEVNULL, stdout=stdout, stderr=stderr, timeout=15)


def check(name, actual, status, stdout, stderr):
    observed = actual.returncode, actual.stdout, actual.stderr
    if observed != (status, stdout, stderr):
        raise RuntimeError(f"{name}: expected {(status, stdout, stderr)!r}, got {observed!r}")
    print(f"PASS {name} (exit {status})", flush=True)


def read_expected(stream, expected):
    ready = b""
    deadline = time.monotonic() + 15
    while ready != expected:
        timeout = max(0, deadline - time.monotonic())
        if not select.select([stream], [], [], timeout)[0]:
            raise RuntimeError(f"child readiness timed out after {ready!r}")
        data = os.read(stream.fileno(), len(expected) - len(ready))
        ready += data
        if not data or not expected.startswith(ready):
            raise RuntimeError(f"unexpected readiness output {ready!r}")


def late_close(binary, implementation, mode):
    # Close the read end only after the child has successfully flushed a
    # partial line. CCL's own shutdown then attempts one additional newline.
    with subprocess.Popen([binary], env=dict(os.environ, HAN_CLI_CASE=mode),
                          stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as proc:
        try:
            read_expected(proc.stdout, b"sent")
            proc.stdout.close()
            proc.stdin.write(b"x\n")
            proc.stdin.flush()
            proc.wait(timeout=15)
            stderr = proc.stderr.read()
        finally:
            if proc.poll() is None:
                proc.kill()
                proc.wait(timeout=5)
    status = 7 if mode == "late-close-failure" else int(implementation == "ccl")
    actual = subprocess.CompletedProcess([binary], proc.returncode, None, stderr)
    check(mode, actual, status, None, b"")


def interrupt(binary, implementation):
    # Keep stdin open. Reading the readiness line places the signal after the
    # CLI boundary is installed, while the child waits for input.
    with subprocess.Popen([binary], env=dict(os.environ, HAN_CLI_CASE="interrupt"),
                          stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          start_new_session=True) as proc:
        try:
            read_expected(proc.stdout, b"ready\n")
            proc.send_signal(signal.SIGINT)
            proc.wait(timeout=15)
            stdout, stderr = proc.communicate()
        finally:
            if proc.poll() is None:
                proc.kill()
                proc.wait(timeout=5)
    actual = subprocess.CompletedProcess([binary], proc.returncode, stdout, stderr)
    if implementation == "lispworks":
        check("SIGINT while awaiting input", actual, 1,
              os.fsencode(binary) + b" : Interrupted - quitting", b"")
    else:
        check("SIGINT while awaiting input", actual, 1, b"", b"[HAN-PROBE] Interrupted.\n")


def suite(binary, implementation):
    # CCL 1.14 finishes partial lines on its two native streams during shutdown.
    output = b"result\n" if implementation == "ccl" else b"result"
    check("buffered output", run_case(binary, "success"), 0, output, b"")
    check("explicit failure status", run_case(binary, "explicit-status"), 7, b"", b"")
    flush = run_case(binary, "flush-success")
    if flush.returncode != 1 or flush.stdout or not flush.stderr.startswith(b"[HAN-PROBE] "):
        raise RuntimeError(f"failed final flush: {flush!r}")
    print("PASS failed final flush replaces success (exit 1, prefixed stderr)", flush=True)
    check("failed flush preserves explicit status", run_case(binary, "flush-failure"), 7, b"", b"")
    for mode, status in (("optional-progress", 0), ("partial-progress", 0), ("partial-progress-failure", 7)):
        result = subprocess.run(["/bin/sh", "-c", 'exec 2>&-; exec "$@"', "han-cli", binary],
                                env=dict(os.environ, HAN_CLI_CASE=mode),
                                stdin=subprocess.DEVNULL, capture_output=True, timeout=15)
        check(f"{mode} on closed stderr", result, status, b"result\n", b"")
    late_close(binary, implementation, "late-close")
    late_close(binary, implementation, "late-close-failure")
    check("reported error", run_case(binary, "error"), 1, b"", b"[HAN-PROBE] expected failure\n")
    with open(os.devnull, "rb") as readonly_stderr:
        check("required write to unwritable stderr",
              run_case(binary, "required-stderr", stderr=readonly_stderr), 1, b"", None)
        check("unwritable stderr", run_case(binary, "error", stderr=readonly_stderr), 1, b"", None)
        with broken_pipe() as stdout:
            check("broken stdout and unwritable stderr",
                  run_case(binary, "success", stdout=stdout, stderr=readonly_stderr), 1, None, None)
    with broken_pipe() as stdout:
        result = run_case(binary, "success", stdout=stdout)
    if result.returncode != 1 or not result.stderr.startswith(b"[HAN-PROBE] "):
        raise RuntimeError(f"broken stdout: exit={result.returncode}, stderr={result.stderr!r}")
    print("PASS broken stdout (exit 1, prefixed stderr)", flush=True)
    interrupt(binary, implementation)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("implementation", choices=("sbcl", "ecl", "ccl", "lispworks"))
    parser.add_argument("--lisp", help="path to the implementation executable")
    args = parser.parse_args()
    executable = shutil.which(args.lisp or args.implementation)
    if not executable:
        parser.error(f"cannot find {args.lisp or args.implementation}")
    flags = {"sbcl": ["--noinform", "--no-userinit", "--no-sysinit", "--script"],
             "ecl": ["-norc", "-shell"], "ccl": ["--no-init", "--batch", "--quiet", "--load"],
             "lispworks": ["-build"]}[args.implementation]
    scripts = Path(__file__).resolve().parent
    with tempfile.TemporaryDirectory(prefix="han-cli-") as directory:
        env = dict(os.environ, HAN_CLI_ROOT=str(scripts.parent) + os.sep,
                   XDG_CACHE_HOME=str(Path(directory) / "cache"))
        build = subprocess.run([executable, *flags, scripts / "build-cli-probe.lisp"],
                               env=env, cwd=directory, capture_output=True, timeout=240)
        binary = Path(directory) / "probe"
        if build.returncode or not binary.is_file():
            raise RuntimeError((build.stdout + build.stderr).decode(errors="replace"))
        suite(binary, args.implementation)


if __name__ == "__main__":
    main()
