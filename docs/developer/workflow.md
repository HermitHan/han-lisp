# Making and testing a change

[简体中文](workflow.zh-CN.md) · [Architecture and package boundaries](README.md)

## Reproduce the behavior at the REPL

Start in the repository root and evaluate `(load "load-han.dev.lisp")` in a fresh Lisp process. This loads the development system and registers the module tests. A fresh process is useful when another checkout of `han` is installed. Use `(asdf:system-source-file "han.dev")` to see which definition ASDF selected.

Here is a focused test for the [duplicate-option example](README.md). It checks both what the application gets back and what it can report. Binding `*tests*` locally keeps the demonstration from altering the registered suite.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest duplicate-name ()
    (let* ((spec (han.args:parse-args-spec
                  (list (han.args:parse-arg-spec "(--/-n)name=world"))
                  "greet"))
           (input (han.args:parse-args-input '("greet" "-n" "Ada" "--name" "Lin")))
           (result (han.args:bind-args spec input)))
      (han.test:check-equal '(nil :conflict)
                            (multiple-value-list (han.args:get-arg "name" result)))
      (let ((diagnostic (find :conflict (han.args:args-result-diagnostics result)
                              :key #'han.args:arg-diagnostic-code)))
        (han.test:check-true diagnostic)
        (han.test:check-equal :error (han.args:arg-diagnostic-kind diagnostic)))))
  (han.test:run-test 'duplicate-name))
;; => T
```

To keep a regression test like this one, add the `deftest` form alongside the binder tests in [args/test.lisp](../../args/test.lisp). Use the file's package for its test name. Within that package, `(han.test:run-test 'duplicate-name)` selects the case by symbol. Redefine the test after changing it and rerun it at the REPL.

## Change the owning layer

1. Write down the observable contract using actual inputs. For the conflict above, two values and a diagnostic code matter. A message intended for a person can change independently of that code.
2. Edit the file responsible for the behavior. A new public operation needs a declaration in its module's `package.lisp`, a description in both language editions of the [user guide](../user/README.md), and a test for the new contract. Add a [symbol reference entry](../reference/README.md) with at least two executable examples of different behaviors and link it from the package and alphabetical indexes. Update the package’s REPL `help` text if usage changes.
3. When adding a source file, check the serial component lists in [han.asd](../../han.asd) and [han.dev.asd](../../han.dev.asd). The former must load in a clean runtime image. The latter also loads the test files.
4. For host operations, check the SBCL and LispWorks implementations and the fallback at the same time. For a change to process capture, exercise stdout and stderr, a nonzero exit and resource cleanup. For a cursor change, exercise a newline and a rewind. Choose cases that can distinguish an incorrect implementation of the changed behavior.

## Run the suite from the checkout

Use a fresh process. The suite exercises Unix processes and files and needs a writable temporary directory and ASDF cache, plus ordinary Unix shell utilities. This command exits unsuccessfully for a failed test or an empty suite.

```sh
sbcl --noinform --no-sysinit --no-userinit --disable-debugger \
  --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

In a LispWorks REPL with ASDF available, load `load-han.dev.lisp` from the checkout and evaluate `(han.test:run-all-tests)`. The two returned integers are the number passed and failed. See [the runtime loader](../../load-han.lisp) and [the development loader](../../load-han.dev.lisp) when diagnosing a load that succeeds but registers no module tests.

For portability changes, run the same source and regression cases on **macOS/SBCL, macOS/LispWorks, Linux/SBCL and Linux/LispWorks**, the four maintainer targets. Record the OS and Lisp versions and the outcome for each target, marking any combination that was not run.

For a synchronous process, compare the ordinary exit code and captured stderr with a direct run of the same tool on that machine. Check stdout, stderr and exit status in return order, then repeat a nonzero exit with `:ignore-error-status nil` and assert `simple-error`. Exercise signal termination separately using the historical convention for that backend. For an encoding promise compare file bytes, and for a pathname compare the components the API promises. [Portability boundary](README.md#portability-boundary)

## Measure runtime coverage on SBCL

With a fresh compilation cache, run `XDG_CACHE_HOME="$(mktemp -d)" sbcl --script scripts/check-coverage.lisp /tmp/han-coverage/`. Open `cover-index.html` in the chosen report directory to see which expressions and branch outcomes the module and CLI tests exercised. The [coverage script](../../scripts/check-coverage.lisp) selects the runtime files from `han.asd` and starts counting after loading. It measures the current SBCL process. The symbol reference examples and LispWorks suite run separately.

## Compare network failures and malformed UTF-8

Run the optional probe on macOS or Linux with Python 3, curl with Unix socket, HTTPS and DNS-over-HTTPS (DoH) support, and the `openssl` command-line tool. The three commands select SBCL, a batch-capable LispWorks installation, or an interactive LispWorks Listener, respectively.

```sh
python3 scripts/check-host-boundaries.py
python3 scripts/check-host-boundaries.py --lispworks /path/to/lispworks
python3 scripts/check-host-boundaries.py --listener
```

For Personal Edition, open a fresh Listener and run the third command in a terminal. Evaluate the printed `(load ...)` form in the Listener. Keep the terminal command running until the local services receive the requests and the probe reports its results.

The probe runs curl directly on the same machine to obtain a reference exit status, then compares it with the result from `han.os:run-program`. In ordinary mode (`:ignore-error-status t`, the default), the three return values for these failures are empty stdout, a diagnostic on stderr and curl’s nonzero exit code. Strict mode (`:ignore-error-status nil`) signals `simple-error` for a nonzero exit. [Probe script](../../scripts/check-host-boundaries.py)

Each `RESULT` line records both diagnostics verbatim and the condition reported by Han in strict mode. The comparison ignores elapsed milliseconds, which can change between calls. Two machines can report different native errors for the same unavailable proxy.

| Case | What the probe exercises |
| --- | --- |
| Connection and read timeout | curl tries an unusable Unix socket and a loopback TCP port with no listener. A separate local HTTP server accepts requests and sends no response, so the client times out after connecting. |
| DNS | curl asks the probe’s loopback HTTPS server to resolve `han-probe.invalid.` over DoH. The server replies `NXDOMAIN` (the name does not exist). The probe uses `--doh-insecure` only for the connection to this self-signed resolver. All DNS queries stay on loopback. |
| Proxy | curl is explicitly directed through an unreachable loopback proxy. Its failure is compared with a direct invocation of curl using the same proxy settings. |
| TLS trust | A separate request tests the origin server’s certificate verification. The local HTTPS server presents a temporary self-signed certificate. The failure is paired with a successful request to the same origin using `--cacert` and the temporary certificate. |

The probe also records how the host UTF-8 decoder handles an invalid continuation byte and a truncated sequence at end of file. Inspect the returned characters or the condition type to distinguish decoder behavior from a JSON syntax error.

## Verify the symbol reference

From the checkout root, run `sbcl --script scripts/check-reference.lisp`. The [checker](../../scripts/check-reference.lisp) compares exported symbols with their pages and both indexes, then reads each example straight from Markdown and runs it in a fresh SBCL process with this checkout loaded. Use a writable temporary directory and ASDF cache. Some examples invoke Unix tools. A failure reports the file, example number and opening line and exits with a nonzero status.

Put at least two fenced `lisp` blocks in the Examples section of each entry. Pick examples where the difference matters: look up a field explicitly set to false, then one that is missing. For a more complex interface, add a failure or show how to release a resource. Use temporary files and make each example runnable on its own at the REPL.

End each block with one expectation:

- `;; => "Ada"` compares the primary value with Common Lisp’s `equal`. String comparisons are case-sensitive. Secondary values are ignored.
- `;; => values (NIL T)` checks every returned value, in order, including the count. Use `values ()` for zero values and `values (NIL)` for a single false value.
- `;; signals han.json:json-error` requires the last top-level form to signal the named error type or a subtype. Name a specific condition. A normal return or an unrelated error fails. Put fallible setup in preceding top-level forms so a setup failure cannot satisfy the expectation.
