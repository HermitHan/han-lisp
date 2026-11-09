# `han.host:call-with-exclusive-file-lock`

[简体中文](call-with-exclusive-file-lock.zh-CN.md)

*Function*

## Syntax

```text
(han.host:call-with-exclusive-file-lock lock-path function &key (timeout 5)) → values returned by function
```

## Description

On macOS and Linux with SBCL, LispWorks or ECL, opens or creates a stable lock file and takes an exclusive `flock` before invoking the zero-argument function. All cooperating processes must keep using the same lock file, including between calls. Returns all callback values and releases the lock on exit. A nonnegative timeout is in seconds. Zero allows one attempt. Failure to obtain the lock by the deadline signals an error. Each example uses its own temporary lock file.

## Examples

Acquire a lock and collect both values returned by its callback.

```lisp
(uiop:with-temporary-file (:pathname lock)
  (multiple-value-list
   (han.host:call-with-exclusive-file-lock
    lock (lambda () (values :written 3)) :timeout 0)))
;; => (:WRITTEN 3)
```

A second independent open cannot acquire the same exclusive lock immediately.

```lisp
(uiop:with-temporary-file (:pathname lock)
  (han.host:call-with-exclusive-file-lock
   lock (lambda ()
          (handler-case
              (han.host:call-with-exclusive-file-lock
               lock (lambda () :unexpected) :timeout 0)
            (simple-error (condition)
              (if (search "Timed out waiting for lock" (princ-to-string condition))
                  :busy
                  (error condition)))))))
;; => :BUSY
```

Abandon one record from inside the callback, then acquire the lock again for the next record.

```lisp
(uiop:with-temporary-file (:pathname lock)
  (let ((first-result
          (catch 'reject-record
            (han.host:call-with-exclusive-file-lock
             lock (lambda () (throw 'reject-record :rejected))))))
    (list first-result
          (han.host:call-with-exclusive-file-lock lock (lambda () :retried) :timeout 0))))
;; => (:REJECTED :RETRIED)
```

[`han.host:append-utf8-line`](append-utf8-line.md) · [`han.host:file-exists-p`](file-exists-p.md) · [common.lisp](../../../host/common.lisp) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [Index](../README.md)
