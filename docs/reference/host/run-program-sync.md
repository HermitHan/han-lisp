# `han.host:run-program-sync`

[简体中文](run-program-sync.zh-CN.md)

*Function*

## Syntax

```text
(han.host:run-program-sync command &key input (output :string) (error-output :string) (ignore-error-status t)) → stdout, stderr, exit-code
```

## Description

Waits for the program and returns three values. A string list denotes argv and a command string invokes shell syntax. Absent input gives EOF. `t` selects standard input, and a character stream supplies its remaining content. For output, `:string` captures text, while `t` or a supplied stream replays text after completion and returns `nil` for that channel. Capture uses temporary files.

An ordinary exit supplies the program's exit code. When a Unix signal terminates the child, SBCL returns the signal number and LispWorks, ECL and CCL return 128 plus that number. Set `ignore-error-status` to `nil` to signal an error for either kind of nonzero status. With direct argv, a missing program or a file lacking execute permission signals a launch error even with the default `ignore-error-status` of `t`.

With `:input t`, SBCL passes the current standard input stream to the backend. LispWorks, ECL and CCL read it into a temporary file up to EOF before launching the child. CCL uses UTF-8 for character input, capture and replay. SBCL, LispWorks and ECL read their capture files using the host’s default external format. A LispWorks image using Latin-1 can display UTF-8 output as separate characters for each byte. When the encoding is known, redirect the tool to a new file and read it with the matching external format.

For direct argv, pass the executable’s full path as the first string. Lookup of a bare name varies by backend. To search for a tool by name, call [`find-executable`](find-executable.md) first and check for `nil`.

On ECL and CCL, `:stream` as a synchronous input, output or error-output designator signals `simple-error` before launch. A synchronous call can capture with `:string`, replay to an existing output stream or `t`, or direct output to a file. To get live pipes, start a child with [run-program](run-program.md).

## Examples

Capture standard output, standard error and the exit code from a single shell command.

```lisp
(multiple-value-list
 (han.host:run-program-sync
  '("/bin/sh" "-c" "printf out; printf err >&2; exit 3")))
;; => ("out" "err" 3)
```

Pass UTF-8 text and shell metacharacters as one literal argument. The child prints the bytes in hexadecimal so the result can be read in any of the supported text encodings.

```lisp
(multiple-value-list
 (han.host:run-program-sync
  '("/bin/sh" "-c" "printf %s \"$1\" | od -An -tx1 | tr -d '[:space:]'"
    "show-bytes" "汉 😀 $HOME *")))
;; => ("e6b18920f09f98802024484f4d45202a" "" 0)
```

Feed a stream to a worker and replay stdout to a caller-owned buffer.

```lisp
(with-input-from-string (input "rows")
  (let ((sink (make-string-output-stream)))
    (multiple-value-bind (stdout stderr code)
        (han.host:run-program-sync '("/bin/cat") :input input :output sink)
      (list stdout stderr code (get-output-stream-string sink)))))
;; => (NIL "" 0 "rows")
```

Propagate a failed command as a Lisp error instead of branching on its exit status.

```lisp
(han.host:run-program-sync '("/bin/sh" "-c" "exit 9") :ignore-error-status nil)
;; signals simple-error
```

[`han.host:run-program`](run-program.md) · [`han.os:run-program`](../os/run-program.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [Index](../README.md)
