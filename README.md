# Han Lisp

[简体中文](README.zh-CN.md)

Han is a Common Lisp library for writing command-line tools. It provides argument parsing, subprocess I/O, path handling and JSON in one ASDF system, `han`. It grew out of TAFFISH and can be loaded independently.

## Load Han

Start a Lisp REPL in the repository root and load the checkout.

```lisp
(load "load-han.lisp")
```

The loader registers the checkout with ASDF and loads `han`. If the checkout is already in your ASDF source registry, use `(asdf:load-system "han")` after `(require :asdf)`. The host layer has backends for SBCL and LispWorks. Its implementation-specific operations signal an error on other Lisp implementations.

## At the REPL

`get-json` returns two values, so a program can distinguish an explicit JSON `false` from an absent key.

```lisp
(let ((config (han.json:parse-json "{\"enabled\":false}")))
  (list (multiple-value-list (han.json:get-json config "enabled"))
        (multiple-value-list (han.json:get-json config "missing"))))
;; => ((NIL T) (NIL NIL))
```

Each package provides a `help` function. Try `(han.args:help)` for the argument specification syntax.

| Package | What it provides |
| --- | --- |
| `han.args` | Parse argument specifications, bind command-line arguments and query the result |
| `han.host` | Access OS processes, environment variables, terminals and files through the active Lisp implementation |
| `han.os` | Read streams, find executables and run shell commands |
| `han.path` | Join paths, find parent directories and compute relative paths |
| `han.json` | Parse and encode JSON strings and files |
| `han.source` | Scan text with a cursor and track positions and spans for parsers |
| `han.test` | Define tests, check expectations and run a test suite |

## Run the tests

From the repository root, start a fresh SBCL process with the development system `han.dev`. The tests use UIOP (included with ASDF), a writable temporary directory, a Unix shell with standard utilities and the `USER` environment variable. This command exits with status 1 if a test fails or the suite is empty.

```sh
sbcl --noinform --no-sysinit --no-userinit --disable-debugger \
  --load load-han.dev.lisp \
  --eval '(multiple-value-bind (passed failed) (han.test:run-all-tests)
            (uiop:quit (if (and (plusp passed) (zerop failed)) 0 1)))'
```

## Origin and license

The initial source for this repository comes from [TAFFISH’s `vendor/han` at commit `4697321`](https://github.com/taffish/taffish/tree/4697321b9b8570e5b9862423c62620191bd21522/vendor/han). Han is distributed under the [MIT License](LICENSE).
