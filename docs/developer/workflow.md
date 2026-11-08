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

Use a fresh process. The suite exercises Unix processes and files and needs a writable temporary directory and ASDF cache, ordinary shell utilities and a set `USER` environment variable. This command exits unsuccessfully for a failed test or an empty suite.

```sh
sbcl --noinform --no-sysinit --no-userinit --disable-debugger \
  --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

In a LispWorks REPL with ASDF available, load `load-han.dev.lisp` from the checkout and evaluate `(han.test:run-all-tests)`. The two returned integers are the number passed and failed. For an adapter change, record the OS and Lisp implementation actually exercised and keep any other combination visibly unverified. See [the runtime loader](../../load-han.lisp) and [the development loader](../../load-han.dev.lisp) when diagnosing a load that succeeds but registers no module tests.

## Verify the symbol reference

From the checkout root, run `sbcl --script scripts/check-reference.lisp`. The [checker](../../scripts/check-reference.lisp) compares exported symbols with their pages and both indexes, then reads each example straight from Markdown and runs it in a fresh SBCL process with this checkout loaded. Use a writable temporary directory and ASDF cache. Some examples invoke Unix tools. A failure reports the file, example number and opening line and exits with a nonzero status.

Put at least two fenced `lisp` blocks in the Examples section of each entry. Pick examples where the difference matters: look up a field explicitly set to false, then one that is missing. For a more complex interface, add a failure or show how to release a resource. Use temporary files and make each example runnable on its own at the REPL.

End each block with one expectation:

- `;; => "Ada"` compares the primary value with Common Lisp’s `equal`. String comparisons are case-sensitive. Secondary values are ignored.
- `;; => values (NIL T)` checks every returned value, in order, including the count. Use `values ()` for zero values and `values (NIL)` for a single false value.
- `;; signals han.json:json-error` requires the last top-level form to signal the named error type or a subtype. Name a specific condition. A normal return or an unrelated error fails. Put fallible setup in preceding top-level forms so a setup failure cannot satisfy the expectation.
