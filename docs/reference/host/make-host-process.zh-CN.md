# `han.host:make-host-process`

[English](make-host-process.md)

*结构体构造函数*

## 语法

```text
(han.host:make-host-process &key backend native-handle pid input-stream output-stream error-stream exit-code signal-code) → host-process
```

## 说明

创建结构并按关键字设置各槽，省略的槽默认为 `nil`。构造本身不会启动进程，适用于编写宿主适配代码。操作实际进程时需要当前后端提供的原生资源。

## 示例

构造句柄，再读回它的后端标识和 PID。

```lisp
(let ((handle (han.host:make-host-process :backend :example :pid 17)))
  (list (han.host:host-process-backend handle)
        (han.host:host-process-pid handle)))
;; => (:EXAMPLE 17)
```

为通常读取子进程 stdout 的函数构造由内存流驱动的测试数据。

```lisp
(with-input-from-string (messages (format nil "prepared~%complete~%"))
  (let ((fixture (han.host:make-host-process :output-stream messages)))
    (han.os:load-lines (han.host:host-process-output-stream fixture))))
;; => ("prepared" "complete")
```

[`han.host:host-process`](host-process.zh-CN.md) · [`han.host:run-program`](run-program.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
