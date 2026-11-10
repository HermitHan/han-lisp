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

For every source change, including internal refactoring and bug fixes, check both editions of the README, documentation index, user and developer guides, and entries for affected public symbols. Follow calls through public wrappers. English pages use `.md` and Simplified Chinese pages use `.zh-CN.md`. Link to the matching edition within each guide and provide a language link to the other edition of the same page. When a change affects callers, describe it in English in the next GitHub Release notes.

1. Write down the observable contract using actual inputs. For the conflict above, two values and a diagnostic code matter. A message intended for a person can change independently of that code.
2. Edit the file responsible for the behavior. A new public operation needs a declaration in its module's `package.lisp`, a description in both editions of the [user guide](../user/README.md), and a test for the new contract. Write a [symbol reference entry](../reference/README.md) in each language and link it from that edition’s package and alphabetical indexes. Use the same signature and at least two identical runnable examples covering different behaviors in both editions. Update the package’s REPL `help` text if usage changes.
3. When adding a source file, check the serial component lists in [han.asd](../../han.asd) and [han.dev.asd](../../han.dev.asd). The former must load in a clean runtime image. The latter also loads the test files.
4. For host operations, check the SBCL, LispWorks, ECL and CCL implementations and the fallback at the same time. For a change to process capture, exercise stdout and stderr, a nonzero exit and resource cleanup. For a cursor change, exercise a newline and a rewind. Choose cases that can distinguish an incorrect implementation of the changed behavior.

When adding a host, put its implementation in its own adapter and register it in both ASDF systems. Exercise the existing adapters against the new checkout. If an existing adapter fails, reproduce the behavior on the previous version, specify what the caller should observe, and keep the regression test with that adapter. For a process launch, check which executable ran as well as its working directory, arguments, environment and exit status.

## Run the suite from the checkout

Use a fresh process. The suite exercises Unix processes and files and needs a writable temporary directory and ASDF cache, plus ordinary Unix shell utilities. This command exits unsuccessfully for a failed test or an empty suite.

```sh
sbcl --noinform --no-sysinit --no-userinit --disable-debugger \
  --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

For Unicode-enabled ECL 26.5.5, use the same test entry point. ECL needs a working C compiler for native ASDF compilation. When setting `TMPDIR` for ECL 26.5.5 with bundled ASDF 3.1.8.11, use an existing absolute directory with `..` components resolved (for example, `export TMPDIR="$(mktemp -d)"` from a normal system temp directory). On Linux, UIOP can fail to create a temporary file if the directory name still contains `/../`.

```sh
ecl -norc -nodebug -load load-han.dev.lisp \
  -eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
           (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

For CCL 1.14, set `CCL_BIN` to the absolute kernel path in the full distribution. Use `darm64cl` on Apple Silicon macOS or `lx86cl64` on x86-64 Linux.

```sh
"$CCL_BIN" --no-init --batch --quiet --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (ccl:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

In a LispWorks REPL with ASDF available, load `load-han.dev.lisp` from the checkout and evaluate `(han.test:run-all-tests)`. The two returned integers are the number passed and failed. See [the runtime loader](../../load-han.lisp) and [the development loader](../../load-han.dev.lisp) when diagnosing a load that succeeds but registers no module tests.

For portability changes, run the same source and regression cases on **SBCL, LispWorks, ECL and CCL on both macOS and Linux**. First load `load-han.lisp` in a clean runtime. Use a separate process for `load-han.dev.lisp`. Record the OS and Lisp versions and the outcome for each target, marking any combination that was not run. For parallel ECL runs, give each process its own `XDG_CACHE_HOME` and absolute `TMPDIR` so native compilations write to separate directories.

For a synchronous process, compare the ordinary exit code and captured stderr with a direct run of the same tool on that machine. Check stdout, stderr and exit status in return order, then repeat a nonzero exit with `:ignore-error-status nil` and assert `simple-error`. Exercise signal termination separately using the historical convention for that backend. For an encoding promise compare file bytes, and for a pathname compare the components the API promises. [Portability boundary](README.md#portability-boundary)

Load `scripts/check-lock-interop.lisp` from the checkout in each tested implementation. An ECL parent starts SBCL, while SBCL and LispWorks parents start ECL. A CCL parent defaults to SBCL. To test both directions with CCL, set `HAN_LOCK_PEER_IMPL` to `sbcl`, `ecl` or `ccl` and set `HAN_LOCK_PEER` to the matching executable’s full path. The probe holds the same lock file across processes, swaps the holder and contender to check timeouts in both processes, terminates a lock holder with SIGKILL, and verifies that the next acquisition returns both callback values.

For an atomic replacement change, test a previously absent target and an existing file. Keep a reader open across the rename, verify the filename and permissions of the new file, and check that the staged name disappears. Use a second filesystem to exercise failure against both an existing and a missing target. Verify that the source and the target each retain their pre-call state. [File replacement contract](../reference/host/atomic-replace-file.md) · [Host tests](../../host/test.lisp)

## Test the executable entry point

Run `python3 scripts/check-cli-boundaries.py ccl --lisp "$CCL_BIN"` to build a Han probe and exercise it from a separate process. Substitute `sbcl`, `ecl` or `lispworks` and the matching executable to test another backend. For LispWorks executable tests, use an edition with Delivery. The probe sends SIGINT after startup, closes the reader of the stdout pipe, and makes stderr unwritable. It checks the exit status and both output channels, including an explicitly requested nonzero status and optional progress output whose failure the application has already handled. [CLI process tests](../../scripts/check-cli-boundaries.py)

When investigating long Unicode arguments, pass them from a parent process, then compare the original UTF-8 bytes, the decoded Lisp argument and the serialized output. A string constructed inside the child bypasses OS argument decoding. [Argument contract](../reference/host/argv.md)

## Check TAFFISH as a consumer

Start with an isolated copy of a recorded TAFFISH revision, including any prerequisite patches. Replace its `vendor/han` with the candidate Han sources, both ASDF systems, loaders and tests. Verify that `(asdf:system-source-file "han")` points inside that copy. Run the TAFFISH development suite. Where the runtime can deliver executables, build `taf`, `taffish` and `taffish-mcp`, run their external tests, and compare representative CLI and MCP outputs, diagnostics and exit codes with the pinned vendor on the same machine. Record source revisions or digests, runtimes, failures, skips and reruns. macOS LispWorks Personal covers the source suite in its Listener. Linux LispWorks Professional also covers delivered binaries.

When a fix requires a new Han operation, compare the pinned vendor, the upgraded vendor with the original caller, and the upgraded vendor with the new call. For Hub repair, TAFFISH uses [`atomic-replace-file`](../reference/host/atomic-replace-file.md) only after its transaction authorizes replacement. Check consecutive updates to `journal.json`, replacement of an extensionless launcher, protection of backups and directories, and recovery after an injected failure. TAFFISH maintains the integration in its own repository.

## Measure runtime coverage on SBCL

With a fresh compilation cache, run `XDG_CACHE_HOME="$(mktemp -d)" sbcl --script scripts/check-coverage.lisp /tmp/han-coverage/`. Open `cover-index.html` in the chosen report directory to see which expressions and branch outcomes the module and CLI tests exercised. The [coverage script](../../scripts/check-coverage.lisp) selects the runtime files from `han.asd` and starts counting after loading. It measures the current SBCL process. CCL, ECL, LispWorks and the reference example workers run separately.

## Compare network failures and malformed UTF-8

Run the optional probe on macOS or Linux with Python 3, curl with Unix socket, HTTPS and DNS-over-HTTPS (DoH) support, and the `openssl` command-line tool. The default is SBCL. Use `--ccl`, `--ecl` or `--lispworks` with the executable to select a batch runtime. For a graphical LispWorks Listener use `--listener`.

```sh
python3 scripts/check-host-boundaries.py
python3 scripts/check-host-boundaries.py --ccl "$CCL_BIN"
python3 scripts/check-host-boundaries.py --ecl "$(command -v ecl)"
python3 scripts/check-host-boundaries.py --lispworks /path/to/lispworks
python3 scripts/check-host-boundaries.py --listener
```

For Personal Edition, open a fresh Listener and run the `--listener` command in a terminal. Evaluate the printed `(load ...)` form in the Listener. Keep the terminal command running until the local services receive the requests and the probe reports its results.

The probe runs curl directly on the same machine to obtain a reference exit status, then compares it with the result from `han.os:run-program`. In ordinary mode (`:ignore-error-status t`, the default), the three return values for these failures are empty stdout, a diagnostic on stderr and curl’s nonzero exit code. Strict mode (`:ignore-error-status nil`) signals `simple-error` for a nonzero exit. [Probe script](../../scripts/check-host-boundaries.py)

Each `RESULT` line records both diagnostics verbatim and the condition reported by Han in strict mode. The comparison ignores elapsed milliseconds, which can change between calls. Two machines can report different native errors for the same unavailable proxy.

| Case | What the probe exercises |
| --- | --- |
| Connection and read timeout | curl tries an unusable Unix socket and a loopback TCP port with no listener. A separate local HTTP server accepts requests and sends no response, so the client times out after connecting. |
| DNS | curl asks the probe’s loopback HTTPS server to resolve `han-probe.invalid.` over DoH. The server replies `NXDOMAIN` (the name does not exist). The probe uses `--doh-insecure` only for the connection to this self-signed resolver. All DNS queries stay on loopback. |
| Proxy | curl is explicitly directed through an unreachable loopback proxy. Its failure is compared with a direct invocation of curl using the same proxy settings. |
| TLS trust | A separate request tests the origin server’s certificate verification. The local HTTPS server presents a temporary self-signed certificate. The failure is paired with a successful request to the same origin using `--cacert` and the temporary certificate. |

The probe also records how the host UTF-8 decoder handles an invalid continuation byte and a truncated sequence at end of file. Inspect the returned characters or the condition type to distinguish decoder behavior from a JSON syntax error. On CCL 1.14 it asserts the replacement character in the first case and a JSON error for the unclosed string in the second.

## Verify the symbol reference

From the checkout root, run `sbcl --script scripts/check-reference.lisp`, `ecl -norc -shell scripts/check-reference.lisp` and `"$CCL_BIN" --no-init --batch --quiet --load scripts/check-reference.lisp`. The [checker](../../scripts/check-reference.lisp) matches exported symbols to both editions of their pages and checks the package and alphabetical indexes in each language. It compares each pair’s symbol name, signature and example blocks, including the expected results. Each matching example runs once per invocation, in a fresh process of the selected implementation with this checkout loaded.

The checker has batch workers for SBCL, ECL and CCL. On LispWorks, load the checkout in a fresh Listener or development image and run the affected example blocks there, checking the values or conditions against their final comments. Some examples launch an additional child Lisp. They use the running kernel on ECL and CCL and the `sbcl` command on other hosts. Use a writable temporary directory and ASDF cache. Some examples invoke Unix tools. A failed batch example reports the file, example number and opening line and exits with a nonzero status.

Put at least two fenced `lisp` blocks in the Examples section of each entry. Pick examples where the difference matters: look up a field explicitly set to false, then one that is missing. For a more complex interface, add a failure or show how to release a resource. Use temporary files and make each example runnable on its own at the REPL.

End each block with one expectation:

- `;; => "Ada"` compares the primary value with Common Lisp’s `equal`. String comparisons are case-sensitive. Secondary values are ignored.
- `;; => values (NIL T)` checks every returned value, in order, including the count. Use `values ()` for zero values and `values (NIL)` for a single false value.
- `;; signals han.json:json-error` requires the last top-level form to signal the named error type or a subtype. Name a specific condition. A normal return or an unrelated error fails. Put fallible setup in preceding top-level forms so a setup failure cannot satisfy the expectation.
