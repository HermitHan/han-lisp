# `han.os:escape-sh-token`

[简体中文](escape-sh-token.zh-CN.md)

*Function*

## Syntax

```text
(han.os:escape-sh-token value) → quoted-token string
```

## Description

Quotes a value as a single POSIX shell word by delegating to `han.host:escape-sh-token`. The result includes the surrounding quotes, and an embedded apostrophe is escaped. `nil` represents an empty string. Use the returned text only when assembling shell syntax.

## Examples

Compare a quoted word with the same value passed as a separate argument. The shell checks the accent, apostrophe, space and literal dollar sign and reports the result through its exit status. Text captured from a process uses the host’s default external format.

```lisp
(let ((word "l'été $HOME"))
  (han.os:run-program
   (list "/bin/sh" "-c"
         (format nil "test ~A = \"$1\"" (han.os:escape-sh-token word))
         "check-word" word)))
;; => values ("" "" 0)
```

Preserve an empty positional argument between two nonempty arguments.

```lisp
(let ((quoted (mapcar #'han.os:escape-sh-token '("one" "" "three"))))
  (han.os:run-shell-command (format nil "printf '<%s>' ~{~A~^ ~}" quoted)
                            :shell "/bin/sh" :lines nil))
;; => values ("<one><><three>" "" 0)
```

[`han.os:run-shell-command`](run-shell-command.md) · [`han.host:escape-sh-token`](../host/escape-sh-token.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [Index](../README.md)
