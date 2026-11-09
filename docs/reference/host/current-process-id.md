# `han.host:current-process-id`

[简体中文](current-process-id.zh-CN.md)

*Function*

## Syntax

```text
(han.host:current-process-id) → positive integer
```

## Description

Returns the OS process ID of the currently running Lisp. The number is assigned by the operating system. To inspect a child, read the PID slot of the child's handle.

## Examples

Check that the running Lisp process has a positive integer PID.

```lisp
(let ((pid (han.host:current-process-id)))
  (and (integerp pid) (plusp pid)))
;; => T
```

Tag log records with the current PID and recognize records written by this process.

```lisp
(uiop:with-temporary-file (:pathname log)
  (han.host:append-utf8-line log (write-to-string (han.host:current-process-id)))
  (= (parse-integer (first (han.os:load-lines log))) (han.host:current-process-id)))
;; => T
```

[`han.host:host-process-pid`](host-process-pid.md) · [`han.host:run-program`](run-program.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
