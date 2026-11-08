# `han.host:call-with-exclusive-file-lock`

*Function · 函数*

## Syntax · 语法

```text
(han.host:call-with-exclusive-file-lock lock-path function &key (timeout 5)) → values returned by function
```

## Description · 说明

On macOS and Linux with SBCL or LispWorks, opens or creates a stable lock file and takes an exclusive `flock` before invoking the zero-argument function. All cooperating processes must keep using the same lock file, including between calls. Returns all callback values and releases the lock on exit. A nonnegative timeout is in seconds. Zero allows one attempt. Failure to obtain the lock by the deadline signals an error. Each example uses its own temporary lock file.

在 macOS 或 Linux 的 SBCL、LispWorks 上打开或创建稳定的锁文件，取得 `flock` 独占锁后调用无参函数。合作进程应持续使用同一锁文件，两次调用之间也应保留。返回回调的全部值，退出时释放锁。超时以秒计且必须非负，零表示仅尝试一次，超时未取得锁则报错。每个示例均使用各自的临时锁文件。

## Examples · 示例

Acquire a lock and collect both values returned by its callback.

取得锁并收集回调返回的两个值。

```lisp
(uiop:with-temporary-file (:pathname lock)
  (multiple-value-list
   (han.host:call-with-exclusive-file-lock
    lock (lambda () (values :written 3)) :timeout 0)))
;; => (:WRITTEN 3)
```

A second independent open cannot acquire the same exclusive lock immediately.

两次独立打开同一锁文件时，第二次无法立即获得仍由外层持有的锁。

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

从回调内部提前放弃一条记录，再次获得同一把锁处理下一条。

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

[`han.host:append-utf8-line`](append-utf8-line.md) · [`han.host:file-exists-p`](file-exists-p.md) · [common.lisp](../../../host/common.lisp) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [Index · 索引](../README.md)
