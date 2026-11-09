# `han.host:current-process-id`

[English](current-process-id.md)

*函数*

## 语法

```text
(han.host:current-process-id) → positive integer
```

## 说明

返回当前 Lisp 进程的操作系统 PID，是系统分配的正整数。需要子进程的 PID 时，从子进程句柄上读取。

## 示例

检查当前 Lisp 进程的 PID 是否为正整数。

```lisp
(let ((pid (han.host:current-process-id)))
  (and (integerp pid) (plusp pid)))
;; => T
```

给日志记录标记 PID，读回时判断是否为当前进程所写。

```lisp
(uiop:with-temporary-file (:pathname log)
  (han.host:append-utf8-line log (write-to-string (han.host:current-process-id)))
  (= (parse-integer (first (han.os:load-lines log))) (han.host:current-process-id)))
;; => T
```

[`han.host:host-process-pid`](host-process-pid.zh-CN.md) · [`han.host:run-program`](run-program.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
