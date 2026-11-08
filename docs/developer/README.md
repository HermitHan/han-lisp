# Developing Han

[简体中文](README.zh-CN.md) · [Project overview](../../README.md) · [Making and testing a change](workflow.md) · [Symbol reference](../reference/README.md)

Place a change with the code that owns its data and can interpret its result. Reading a child process's exit status belongs to the host adapter. Choosing a message for that status belongs to the application that ran the command.

## How the system fits together

[han.asd](../../han.asd) loads the runtime serially in the order `test → host → source → os → path → json → args`. The call relationships are more selective. `han.os` delegates process operations to `han.host`, `han.path` delegates filesystem operations to it, and `han.args` can obtain the current argv from it. An explicit argv lets a caller replay an invocation in the REPL. The JSON parser uses recursive descent over a string and integer offsets. Parser authors can use the independent cursor in `han.source` for their own grammars.

Each package declares its exports and provides REPL `help` and `version` functions in `package.lisp`. [han.dev.asd](../../han.dev.asd) separately enumerates the implementation files and module tests and declares a UIOP dependency. Check both ASDF definitions when adding an implementation file. The test framework ships in the runtime. The development system registers the library's test cases.

## What belongs in each package

| Package | Design, source and boundary |
| --- | --- |
| [han.host](../../host/) | A common process handle and function interface wrap native handles. [common.lisp](../../host/common.lisp) prepares synchronous I/O, capture files and cleanup. The [SBCL](../../host/sbcl.lisp) and [LispWorks](../../host/lispworks.lisp) adapters launch processes, query status and deal with terminals and file descriptors. Start here for an operation that requires an implementation API, and check the [fallback for other implementations](../../host/unsupported.lisp). |
| [han.os](../../os/) | Organizes operations around what a caller needs to get back. [run-shell.lisp](../../os/run-shell.lisp) selects a shell and can return lines or raw strings using host primitives. [io.lisp](../../os/io.lisp) owns reading, and [env.lisp](../../os/env.lisp) owns environment and command lookup. An individual tool owns its environment variable names and exit policy. |
| [han.path](../../path/core.lisp) | Works with directory components, names, types and relationships between pathnames. `directory-pathname` interprets input as a directory, while `directory-exists-p` probes the filesystem. Add rules for joining or normalizing paths here. Reuse host operations for probing, enumerating and copying real files. |
| [han.source](../../source/char-source.lisp) | Owns character movement and position accounting. Each cursor gets a copy of the input and its own identity. Marks retain index, line and column, and spans hold offsets from a common origin. Check all three coordinates when changing newline handling or rewind. A consuming parser owns quotation, comments and other grammar rules. |
| [han.args](../../args/) | Represents the specification, input and binding result as separately inspectable objects. Lexing recognizes argv shapes, binding interprets them against a specification, and lookup resolves referenced defaults. The application formats diagnostics and supplies any built-in bindings it derives from its environment. See the worked example below for the source files. |
| [han.json](../../json/core.lisp) | The reader and writer share a Lisp representation. Objects use string-keyed hash tables, arrays use vectors, false is `nil`, and null is `:null`. Object lookup preserves presence and the writer sorts object keys. This package signals `json-error` for malformed JSON. A consuming application validates its own required fields. |
| [han.test](../../test/core.lisp) | A dynamically bindable registry holds names and test functions. Redefining a test with the same symbol replaces its registration, which supports iteration at the REPL. Put assertions and runner logic here, and put behavior tests with their owning module, for example in [args/test.lisp](../../args/test.lisp). |

## Trace an argument conflict

Suppose `(--/-n)name=world` takes a single value and a caller supplies `-n Ada --name Lin`. Either spelling works on its own. Only the specification establishes that the two tokens refer to the same option.

| Stage | What happens in this case |
| --- | --- |
| [Specification](../../args/spec.lisp) | `parse-arg-spec` gives the name its short and long entries. `parse-args-spec` collects and validates the command's declarations. |
| [Lexing](../../args/lexer.lisp) | `parse-args-input` separates the command name from argv and retains the original text and positions of the options and their values. |
| [Binding](../../args/bind.lisp) | The binder starts with a copy of the lexer diagnostics. Here the single-value resolver receives two candidates. It produces a binding with status `:conflict` and an error diagnostic with code `:conflict`. |
| [Lookup](../../args/query.lisp) | `get-arg` returns `nil` and `:conflict`. The caller can turn `args-result-diagnostics` into a message or check the code in a test. |

For a new option spelling, first check how the lexer classifies the input. To change how two candidates are resolved, work in the binder. The [development workflow](workflow.md) shows how to replay and test this case.
