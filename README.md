# Han Lisp

[简体中文](README.zh-CN.md) · [User guide](docs/user/README.md) · [Developer guide](docs/developer/README.md) · [Symbol reference](docs/reference/README.md)

Han is a Common Lisp foundation library for programs that work with command lines, files, processes and structured data. Its purpose is to let an application describe its own work in Lisp while sharing the code that interprets arguments, talks to the operating system and reports results. The library grew out of TAFFISH and loads independently as the ASDF system `han`.

## Design

- **Keep application decisions with the caller.** The argument binder can report a missing required option. The program using it chooses the message, its language and the exit code.
- **Return enough information to act.** A subprocess call can return standard output, standard error and an exit code as three values. A JSON lookup returns both a value and a presence flag, so a configuration can explicitly set a field to false.
- **Give implementation differences a home.** SBCL and LispWorks implement process handles and runtime I/O differently. The `han.host` package provides a shared interface that the other packages can use. The runtime system has no declared third-party Lisp dependencies.

## Load Han

Clone [this repository](https://github.com/HermitHan/han-lisp) and start a Lisp REPL in its root directory. Load the library and try turning an argument into a JSON result.

```lisp
(load "load-han.lisp")

(let* ((option (han.args:parse-arg-spec "(--/-n)name=world"))
       (spec (han.args:parse-args-spec (list option) "greet"))
       (input (han.args:parse-args-input '("greet" "-n" "Ada")))
       (result (han.args:bind-args spec input)))
  (han.json:encode-json
   (han.json:json-object (cons "hello" (han.args:get-arg "name" result)))
   :indent nil))
;; => "{\"hello\":\"Ada\"}"
```

With just `'("greet")` as input the same specification supplies `"world"`. When accepting argv from a user, check `args-result-diagnostics` for errors before using the value. The [worked example](docs/developer/README.md) shows what happens when both spellings are supplied.

Once ASDF can find this checkout, another system can declare `:depends-on ("han")`. [Loading and everyday use](docs/user/README.md)

## Packages

| Package | What it owns |
| --- | --- |
| [han.args](docs/user/args.md) | Command-line argument specifications, token positions, bindings and diagnostics |
| [han.os](docs/user/os.md) | Reading streams and files, environment lookups and running commands |
| [han.path](docs/user/path.md) | Building, resolving and inspecting pathnames and working with files and directories |
| [han.host](docs/user/host.md) | SBCL and LispWorks adapters, process handles, terminal I/O and file locking |
| [han.json](docs/user/json.md) | Translating between JSON and Lisp values, querying objects and writing files |
| [han.source](docs/user/source.md) | Moving a cursor through text, saving positions and extracting spans for parsers |
| [han.test](docs/user/test.md) | Defining tests, checking expectations and running registered cases |

## Run the tests

Load the development system `han.dev` in a fresh Lisp process to register the library’s own tests. The developer guide includes the [test command](docs/developer/workflow.md) and the [source map and package boundaries](docs/developer/README.md).

## Origin and license

The first standalone revision contains [the Han sources from TAFFISH v0.11.0](https://github.com/taffish/taffish/tree/4697321b9b8570e5b9862423c62620191bd21522/vendor/han). Han is distributed under the [MIT License](LICENSE).
