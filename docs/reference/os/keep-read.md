# `han.os:keep-read`

[简体中文](keep-read.zh-CN.md)

*Function*

## Syntax

```text
(han.os:keep-read &optional (stream *standard-input*) (limit nil)) → list of Lisp objects
```

## Description

Calls `read` repeatedly, returning Lisp objects in input order. EOF ends the read. An integer limit can bound the result count. A function limit is called before every read with the already-read list in reverse order. Reading stops when it returns false. Standard Lisp reader syntax and the caller's reader settings apply. Reader errors propagate.

## Examples

Read two Lisp objects, then collect the remaining objects from the same stream.

```lisp
(with-input-from-string (input "10 (20 30) 40")
  (let ((*read-eval* nil))
    (list (han.os:keep-read input 2) (han.os:keep-read input))))
;; => ((10 (20 30)) (40))
```

Stop after a Lisp sentinel and continue parsing the remaining forms separately.

```lisp
(with-input-from-string (in "10 :end (:next 20)")
  (let ((*read-eval* nil))
    (list (han.os:keep-read in (lambda (rev) (not (eq (first rev) :end))))
          (read in))))
;; => ((10 :END) (:NEXT 20))
```

[`han.os:keep-read-line`](keep-read-line.md) · [`han.os:keep-read-char`](keep-read-char.md) · [io.lisp](../../../os/io.lisp) · [Index](../README.md)
