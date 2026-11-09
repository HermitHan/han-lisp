# `han.os:run-shell-command`

[简体中文](run-shell-command.zh-CN.md)

*Function*

## Syntax

```text
(han.os:run-shell-command command &key (wait t) (lines t) shell) → stdout, stderr, status (and a handle in asynchronous mode)
```

## Description

Executes shell text using `-c` with the supplied shell pathname, or searches for `bash` and then `sh`. By default it waits and returns stdout and stderr as line lists plus the exit code. `:lines nil` preserves output as strings. With `:wait nil` it returns the two readable pipes, `nil` and a child handle. The caller drains the pipes, waits, inspects the exit code and closes the handle. An invalid shell path signals an error.

## Examples

Write to both output streams and collect each stream together with the nonzero exit code.

```lisp
(multiple-value-list
 (han.os:run-shell-command "printf ok; printf note >&2; exit 5"
                           :shell "/bin/sh"))
;; => (("ok") ("note") 5)
```

Capture raw strings with their terminating newlines for a text protocol.

```lisp
(multiple-value-bind (out err code)
    (han.os:run-shell-command "printf 'ok\\n'; printf 'note\\n' >&2"
                              :shell "/bin/sh" :lines nil)
  (list (string= out (format nil "ok~%")) (string= err (format nil "note~%")) code))
;; => (T T 0)
```

Consume asynchronous stdout and stderr and obtain the actual exit status from the handle.

```lisp
(multiple-value-bind (out err initial child)
    (han.os:run-shell-command "printf ok; printf detail >&2; exit 2"
                              :shell "/bin/sh" :wait nil)
  (unwind-protect
       (let ((line (read-line out nil)) (note (read-line err nil)))
         (han.host:process-wait child)
         (list line note initial (han.host:process-exit-code child)))
    (han.host:process-close child)))
;; => ("ok" "detail" NIL 2)
```

[`han.os:escape-sh-token`](escape-sh-token.md) · [`han.os:run-program`](run-program.md) · [`han.host:process-wait`](../host/process-wait.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [Index](../README.md)
