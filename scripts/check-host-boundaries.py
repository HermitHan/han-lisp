"""Compare direct curl failures with the results returned by Han on this host."""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import socket
import subprocess
import sys
import tempfile
import time

from probe_tls import tls_fixture


def curl_cases(curl, blocked_port, silent_port, https_url, doh_url):
    base = [curl, "--disable", "--silent", "--show-error", "--http1.1", "--ipv4"]
    direct = base + ["--noproxy", "*", "--max-time", "2"]
    local = "http://127.0.0.1"
    return [
        ("UNIX-CONNECT-FAILURE", (7,), direct + [
            "--unix-socket", "/dev/null/han-probe.sock", f"{local}/han-probe"]),
        ("TCP-NO-LISTENER", (7, 28), direct + [f"{local}:{blocked_port}/han-probe"]),
        ("HTTP-READ-TIMEOUT", (28,), direct + [f"{local}:{silent_port}/han-probe"]),
        ("DNS-NXDOMAIN", (6,), base + ["--noproxy", "*", "--max-time", "8",
                                      "--doh-url", doh_url, "--doh-insecure",
                                      "http://han-probe.invalid./han-probe"]),
        # Force the proxy even when the environment normally exempts loopback.
        ("PROXY-CONNECT-FAILURE", (7, 28), base + ["--noproxy", "", "--max-time", "2",
                                                   "--proxy", f"{local}:{blocked_port}", https_url]),
        ("TLS-UNTRUSTED-CERTIFICATE", (60,), base + ["--noproxy", "*", "--max-time", "8",
                                                     https_url]),
    ]


def check_native(name, allowed_codes, argv, env):
    result = subprocess.run(argv, env=env, capture_output=True, timeout=15)
    diagnostic = result.stderr.decode("utf-8")
    if result.returncode not in allowed_codes or result.stdout or not diagnostic:
        raise RuntimeError(f"direct {name}: exit={result.returncode}, "
                           f"stdout={result.stdout!r}, stderr={diagnostic!r}")
    return {"name": name, "argv": argv, "code": result.returncode, "stderr": diagnostic}


def without_timing(diagnostic):
    # Two independent invocations can report slightly different elapsed times.
    return re.sub(r"\b\d+(?:\.\d+)? (?=milliseconds?\b|ms\b)", "<time> ", diagnostic)


def compare_results(cases, observations):
    if [c["name"] for c in cases] != [o["name"] for o in observations]:
        raise RuntimeError("Han returned a different set or order of cases")
    for case, result in zip(cases, observations):
        native = case["stderr"]
        actual = result["stderr"]
        print("RESULT", json.dumps(dict(result, native_code=case["code"], native_stderr=native,
                                        stderr_identical=(native == actual)), ensure_ascii=True),
              flush=True)
        if without_timing(native) != without_timing(actual):
            raise RuntimeError(f'{case["name"]}: direct curl and Han diagnostics differ')


def verify_timeout_requests(listener):
    # Direct curl and both Han invocations must have connected and sent HTTP.
    listener.settimeout(3)
    for _ in range(3):
        conn, _ = listener.accept()
        conn.settimeout(3)
        with conn, conn.makefile("rb") as request:
            if request.readline(512) != b"GET /han-probe HTTP/1.1\r\n":
                raise RuntimeError("expected the local curl request")
    print("PASS three timeout requests reached the local HTTP fixture", flush=True)


def lisp_string(path):
    return '"' + str(path).replace("\\", "\\\\").replace('"', '\\"') + '"'


def run_in_listener(driver, cases_file, results_file, start_timeout):
    directory = cases_file.parent
    loader = directory / "listener.lisp"
    log = directory / "listener.log"
    pending = directory / "pending.txt"
    status = directory / "status.txt"
    loader.write_text(f"""(in-package :cl-user)
(block listener-probe
  (let ((*han-probe-listener-files* (list {lisp_string(cases_file)} {lisp_string(results_file)})))
    (declare (special *han-probe-listener-files*))
    (let ((outcome
            (handler-case
                (with-open-file (log {lisp_string(log)} :direction :output :if-exists nil
                                     :external-format :utf-8)
                  (unless log (return-from listener-probe :already-started))
                  (let ((*standard-output* log) (*error-output* log) (*trace-output* log))
                    (load {lisp_string(driver)}))
                  "OK")
              (error (c) (format nil "Probe failed (~S): ~A" (type-of c) c)))))
      (with-open-file (out {lisp_string(pending)} :direction :output :if-exists :error
                           :external-format :utf-8)
        (write-line outcome out))
      (rename-file {lisp_string(pending)} {lisp_string(status)})
      outcome)))
""", encoding="utf-8")
    print(f"Within {start_timeout}s, evaluate this form in your Lisp Listener:", flush=True)
    print(f"(load {lisp_string(loader)})", flush=True)
    deadline = time.monotonic() + start_timeout
    started = False
    while not status.exists():
        if not started and log.exists():
            started = True
            deadline = time.monotonic() + 120
            print("Listener started the probe.", flush=True)
        if time.monotonic() >= deadline:
            break
        time.sleep(0.2)
    if log.exists():
        print(log.read_text(encoding="utf-8"), end="", flush=True)
    if not status.exists():
        if started:
            raise RuntimeError("The Listener started but did not finish the probe within 120s.")
        raise RuntimeError("Timed out waiting for the Listener to load the file. "
                           "Run the command again for a fresh load form.")
    outcome = status.read_text(encoding="utf-8").rstrip()
    if outcome != "OK":
        raise RuntimeError(outcome)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--ecl", metavar="EXECUTABLE",
                      help="run the probe using this ECL executable")
    mode.add_argument("--lispworks", metavar="EXECUTABLE",
                      help="use a batch-capable LispWorks in place of SBCL")
    mode.add_argument("--listener", action="store_true",
                      help="print a load form for an already running GUI Listener")
    parser.add_argument("--listener-timeout", type=int, metavar="SECONDS",
                        help="how long to wait for the manual load (default: 600 seconds)")
    args = parser.parse_args()
    if args.listener_timeout is not None and (not args.listener or args.listener_timeout <= 0):
        parser.error("--listener-timeout requires --listener and a positive number of seconds")
    driver = str(Path(__file__).resolve().with_name("probe-host-boundaries.lisp"))
    curl = shutil.which("curl")
    if not curl:
        parser.error("curl must be on PATH")
    if args.ecl:
        command = [args.ecl, "-norc", "-shell", driver]
    elif args.lispworks:
        command = [args.lispworks, "-build", driver]
    else:
        command = ["sbcl", "--noinform", "--no-sysinit", "--no-userinit", "--script", driver]
    env = {k: v for k, v in os.environ.items() if not k.lower().endswith("_proxy")}
    env["LC_ALL"] = "C"
    version = subprocess.check_output([curl, "--disable", "--version"], env=env, text=True)
    print(version.splitlines()[0], flush=True)

    # Keep the blocked port allocated but without a listener for the entire run.
    with socket.socket() as blocked, socket.socket() as silent, tls_fixture(curl) as tls:
        blocked.bind(("127.0.0.1", 0))
        silent.bind(("127.0.0.1", 0))
        silent.listen(4)
        https_url, doh_url, query_count = tls
        cases = [check_native(name, codes, argv, env)
                 for name, codes, argv in curl_cases(curl, blocked.getsockname()[1],
                                                     silent.getsockname()[1], https_url, doh_url)]
        native_queries = query_count()
        if native_queries < 1:
            raise RuntimeError("direct curl did not receive a reply from the local DNS fixture")
        with tempfile.TemporaryDirectory() as temporary:
            cases_file = Path(temporary, "cases.json")
            result_file = Path(temporary, "results.json")
            cases_file.write_text(json.dumps(cases), encoding="utf-8")
            if args.listener:
                try:
                    run_in_listener(driver, cases_file, result_file, args.listener_timeout or 600)
                except RuntimeError as error:
                    print(error, file=sys.stderr)
                    return 1
            else:
                env.update(HAN_PROBE_CASES=str(cases_file), HAN_PROBE_RESULTS=str(result_file))
                result = subprocess.run(command, env=env, timeout=120)
                if result.returncode:
                    return result.returncode
            compare_results(cases, json.loads(result_file.read_text(encoding="utf-8")))
        han_queries = query_count() - native_queries
        if han_queries < 2:
            raise RuntimeError("expected local DNS queries from both Han invocations")
        print(f"PASS local DNS NXDOMAIN replies: direct={native_queries}, Han={han_queries}", flush=True)
        verify_timeout_requests(silent)
    return 0


if __name__ == "__main__":
    sys.exit(main())
