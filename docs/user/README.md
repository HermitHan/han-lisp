# Using Han

[简体中文](README.zh-CN.md) · [Project overview](../../README.md) · [Symbol reference](../reference/README.md)

## Load the library in your program

The following commands load all seven packages. Run the shell commands from the Han checkout, in the directory containing `han.asd`.

| Lisp | How to load Han |
| --- | --- |
| SBCL | `sbcl --load load-han.lisp` |
| LispWorks | In the Listener, evaluate `(load "/path/to/han-lisp/load-han.lisp")` with the actual path to the checkout. |
| ECL 26.5.5 with Unicode | `ecl -norc -load load-han.lisp` |
| 64-bit Clozure CL 1.14 | Set `CCL_BIN` to the absolute path to the kernel in the unpacked CCL distribution (`darm64cl` on Apple Silicon macOS, `lx86cl64` on x86-64 Linux). Run `"$CCL_BIN" --no-init --load load-han.lisp`. |

To load Han directly with ASDF instead, evaluate these forms in order from a REPL in the checkout.

```lisp
(require :asdf)
(asdf:load-asd (truename "han.asd"))
(asdf:load-system "han")
```

In your own ASDF project, add `"han"` to the system’s `:depends-on` list. If your checkout is outside ASDF’s search path, evaluate `(asdf:load-asd (truename "/path/to/han-lisp/han.asd"))` with the actual path in your REPL before loading your system.

Refer to symbols by package, for example `han.os:run-program`. For help from the running version, try `(han.os:help)`. Pass `nil` as the stream to return the help text without printing it.

## Read a command's JSON output

A tool may print diagnostics on stderr even when it succeeds. Capture the streams separately, check the exit code, then parse stdout. This Unix example uses `printf` in place of a program that reports its status as JSON.

```lisp
(multiple-value-bind (out err code)
    (han.os:run-program '("/usr/bin/printf" "%s" "{\"ready\":false}"))
  (unless (eql code 0)
    (error "Command exited with ~S: ~A" code err))
  (multiple-value-list (han.json:get-json (han.json:parse-json out) "ready")))
;; => (NIL T)
```

The second value says the field exists. Change the JSON to `"{}"` to get `(NIL NIL)`. Supplying a list keeps each command argument separate, including text that contains spaces.

## Find an interface

| I want to… | Package guide |
| --- | --- |
| Accept flags, positional arguments or named blocks, and report input errors | [han.args](args.md) |
| Read lines, look up an environment variable or capture a command's output | [han.os](os.md) |
| Construct a pathname, list a directory or copy a file | [han.path](path.md) |
| Manage a child process, inspect a terminal, lock a file or atomically replace it | [han.host](host.md) |
| Read a configuration or emit JSON while preserving false and null | [han.json](json.md) |
| Look ahead in text, restore the cursor or extract the text matched by a parser | [han.source](source.md) |
| Register a test case and assert results in Lisp | [han.test](test.md) |

Each package guide links to the individual symbol entries. If you know the name already, open the [A–Z index](../reference/symbols.md). To run Han's own tests or work on an implementation, see the [development workflow](../developer/workflow.md).
