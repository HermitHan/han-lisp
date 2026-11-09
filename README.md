# Han Lisp

[简体中文](README.zh-CN.md) · [Documentation](docs/README.md) · [Quick start](#load-han) · [Design philosophy](#design-philosophy) · [Packages](#packages)

Han is a Common Lisp library for command-line tools. It handles work these tools share, from parsing arguments and locating input files to running a subprocess and reading its JSON output. All seven packages load together as the ASDF system `han`.

## Documentation

- **[User guide](docs/user/README.md)** — Load Han into your own project and learn to use the packages together, for example to read JSON from a command’s output.
- **[Symbol reference](docs/reference/README.md)** — Browse the public API by package, or use the [A–Z index](docs/reference/symbols.md) if you know the name. Each entry explains the symbol’s use with examples you can run in the REPL. Function entries also describe arguments and return values. A language link opens the same entry in Chinese.
- **[Developer guide](docs/developer/README.md)** — See how the packages fit together, trace an argument conflict through the source and decide where a change belongs. The [development workflow](docs/developer/workflow.md) covers writing and testing that change.

## Load Han

Clone the checkout and start a Lisp REPL with Han loaded. The command below uses SBCL. On macOS or Linux with Unicode-enabled ECL 26.5.5, use `ecl -norc -load load-han.lisp` for the last line. In a LispWorks Listener, evaluate `(load "load-han.lisp")` from the checkout.

```sh
git clone https://github.com/HermitHan/han-lisp.git
cd han-lisp
sbcl --load load-han.lisp
```

At the REPL, read a configuration that turns retries off and leaves the timeout unspecified. Use `multiple-value-list` to see both values returned by each lookup.

```lisp
(defparameter *settings* (han.json:parse-json "{\"retry\":false}"))

(multiple-value-list (han.json:get-json *settings* "retry"))
;; => (NIL T)

(multiple-value-list (han.json:get-json *settings* "timeout"))
;; => (NIL NIL)
```

`get-json` returns the field’s value and a flag indicating whether the key exists. Both lookups return `NIL` as the first value. The second value distinguishes the explicit setting from the missing field.

To use Han from your own ASDF system, add `"han"` to its `:depends-on` list once ASDF can find the checkout. [Loading Han in your program](docs/user/README.md#load-the-library-in-your-program)

## Design philosophy

The six runtime packages outside `han.host` use one ANSI Common Lisp codebase. Implementation calls, operating-system conventions and reader conditionals such as `#+` and `#-` belong in `han.host`. ASDF selects the SBCL, LispWorks or ECL adapter. For example, `han.json` parses four hex digits and combines surrogate pairs; the host maps the resulting Unicode scalar to a Lisp character and opens files in UTF-8.

A shared interface promises the same meaning, not identical observations from different machines. Executable lookup preserves each machine’s search order; a child’s live status reflects what its backend can observe. To obtain an ordinary exit code, wait for the child first. [Portability contracts and limits](docs/developer/README.md#portability-boundary)

Each new host adapter is tested alongside the existing ones. A change to an existing backend starts with a reproducible defect. Before delivery, we also run TAFFISH against the candidate Han sources in its `vendor/han` directory. [Developer workflow](docs/developer/workflow.md#check-taffish-as-a-consumer)

## Packages

| Package guide | What it does | Example entry |
| --- | --- | --- |
| [`han.args`](docs/user/args.md) | Declare options and positional arguments, bind input and inspect diagnostics. | [`get-arg`](docs/reference/args/get-arg.md) |
| [`han.path`](docs/user/path.md) | Construct paths, list directories and copy files. | [`join-path`](docs/reference/path/join-path.md) |
| [`han.os`](docs/user/os.md) | Read text, look up environment variables and capture command output. | [`run-program`](docs/reference/os/run-program.md) |
| [`han.host`](docs/user/host.md) | Work with live process handles, terminal streams and file locks. | [`process-wait`](docs/reference/host/process-wait.md) |
| [`han.json`](docs/user/json.md) | Parse or write JSON and look up fields in an object. | [`get-json`](docs/reference/json/get-json.md) |
| [`han.source`](docs/user/source.md) | Build a text parser with a character cursor, saved positions and source spans. | [`source-reset`](docs/reference/source/source-reset.md) |
| [`han.test`](docs/user/test.md) | Define tests, make assertions and run registered cases. | [`deftest`](docs/reference/test/deftest.md) |

## Run the tests

- **Library tests.** From a fresh REPL in the checkout, load `load-han.dev.lisp` and call `(han.test:run-all-tests)`. [Shell command and prerequisites](docs/developer/workflow.md#run-the-suite-from-the-checkout)
- **Reference examples.** Run `sbcl --script scripts/check-reference.lisp` or `ecl -norc -shell scripts/check-reference.lisp` in the checkout to check the exported symbols and execute the examples printed in the reference. [How examples are checked](docs/developer/workflow.md#verify-the-symbol-reference)

## Origin and license

Han began as the `vendor/han` library in TAFFISH. The standalone project started with the [TAFFISH v0.11.0 sources](https://github.com/taffish/taffish/tree/4697321b9b8570e5b9862423c62620191bd21522/vendor/han) and is distributed under the [MIT License](LICENSE).
