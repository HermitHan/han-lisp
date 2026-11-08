# han.test · Register and run tests

[User guide](README.md) · [简体中文](test.zh-CN.md) · [Package symbol index](../reference/README.md#test)

`han.test` registers named Lisp forms and runs them in the current process. The runtime system `han` includes the framework, so applications can use it in their own tests. The development system `han.dev` also loads Han’s module tests.

## Test a return-value contract

A useful configuration test checks both values from a lookup. The following test catches a change that treats an explicitly false setting as a missing field.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest explicit-false ()
    (let ((config (han.json:parse-json "{\"retry\":false}")))
      (multiple-value-bind (value present-p)
          (han.json:get-json config "retry")
        (han.test:check-true present-p)
        (han.test:check-false value))))
  (han.test:run-test 'explicit-false))
;; Prints a [PASS] line and returns T.
```

The `let` binding gives the example its own registry and restores the previous registry on exit. For an application suite, evaluate its `deftest` forms in the same registry as the runner. Use an empty lambda list. The runner calls each test with zero arguments. Re-evaluating a definition replaces the earlier test with the same symbol, which makes it convenient to work in the REPL. When you call `run-test` from another package, pass the symbol from the package where the test was defined.

A test passes when its body returns normally, including when its last form returns `nil`. Write an assertion for each result that matters. `check-equal` uses Common Lisp `equal`, which suits lists and strings. For general vectors, compare elements with `equalp` in a `check-true` form or compare a list of their elements.

## Verify a particular error

To test malformed input, name the specific condition type the caller handles. Run the suite to get the passed and failed counts as separate values.

```lisp
(let ((han.test:*tests* nil))
  (han.test:deftest reject-trailing-comma ()
    (han.test:check-error (han.json:json-error)
      (han.json:parse-json "[1,]")))
  (multiple-value-list (han.test:run-all-tests)))
;; => (1 0)
```

In Han 0.1.0, when the body of `check-error` finishes normally, the macro signals a `simple-error` inside its own handler. An expected type such as `error`, `simple-error` or `condition` can catch this fallback and produce a false pass. If you genuinely need to assert that *any* error was signaled, collect that result first and make the assertion outside the handler.

```lisp
(han.test:check-true
 (handler-case
     (progn (han.json:parse-json "[1,]") nil)
   (error () t)))
;; => T
```

## Run tests from a script

`run-all-tests` reports counts and leaves the process exit status to the caller. A CI script can require a positive pass count and zero failures. The [development workflow](../developer/workflow.md) gives the command for running Han’s own suite. In a REPL, avoid clearing the shared registry if other projects have already registered tests.

| Export | What it does |
| --- | --- |
| [`*tests*`](../reference/test/var-tests.md) | Special variable holding the current registry. Bind it to `nil` with `let` to isolate a suite. |
| [`(reset-tests)`](../reference/test/reset-tests.md) | Clear the current registry and return `t`. |
| [`(deftest name () &body body)`](../reference/test/deftest.md) | Macro. Register a test under the supplied symbol and return that symbol. |
| [`(run-test name)`](../reference/test/run-test.md) | Run a registered test by symbol. Print a result line and return `t` for a pass or `nil` for an error in the test. An unknown name signals an error to the caller. |
| [`(run-all-tests)`](../reference/test/run-all-tests.md) | Run the current registry in registration order. Print each result and a summary. Return two integers, passed then failed. An empty suite returns two zeros. |
| [`(check-true form)`](../reference/test/check-true.md), [`(check-false form)`](../reference/test/check-false.md) | Macros. Require a non-`nil` or a `nil` primary value, respectively. Return `t` on success and signal an error on failure. |
| [`(check-equal expected form)`](../reference/test/check-equal.md) | Macro. Evaluate both expressions once, compare their primary values with `equal`, and return `t` or signal an error. Use `multiple-value-list` on the form when testing several return values. |
| [`(check-error (condition-type) &body body)`](../reference/test/check-error.md) | Macro. Return `t` when the named condition is caught. A different error from the body propagates. Use a condition type narrow enough to exclude the fallback described above. |
| [`(help &optional stream)`](../reference/test/help.md), [`(version &optional stream)`](../reference/test/version.md) | Return a help string or the version string. Pass `nil` for silent retrieval, or a stream to also print there. Both default to standard output. |

[Package exports](../../test/package.lisp) · [Runner and assertions](../../test/core.lisp) · [Example suite](../../json/test.lisp)
