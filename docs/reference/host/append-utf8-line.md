# `han.host:append-utf8-line`

[简体中文](append-utf8-line.zh-CN.md)

*Function*

## Syntax

```text
(han.host:append-utf8-line path line) → file pathname
```

## Description

Appends the string `line` encoded as UTF-8, followed by one newline. An existing newline is retained. Creates missing parent directories and the file, then returns its pathname. OS strings are treated as literal filenames. An open or write failure signals an error. For multi-process transactions, use a shared lock.

## Examples

Append a Chinese line and an English line, then read them back in order.

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:append-utf8-line file "一")
  (han.host:append-utf8-line file "two")
  (han.os:load-lines file))
;; => ("一" "two")
```

Create missing parent directories on the first write.

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let ((file (han.path:join-path root "history" "events.log")))
         (han.host:append-utf8-line file "start")
         (han.os:load-lines file))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => ("start")
```

Store a blank record deliberately by passing an empty string.

```lisp
(uiop:with-temporary-file (:pathname log)
  (han.host:append-utf8-line log "")
  (han.os:load-lines log))
;; => ("")
```

[`han.host:call-with-exclusive-file-lock`](call-with-exclusive-file-lock.md) · [`han.os:load-lines`](../os/load-lines.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [Index](../README.md)
