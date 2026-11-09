# `han.host:host-process-error-stream`

[English](host-process-error-stream.md)

*访问器*

## 语法

```text
(han.host:host-process-error-stream process) → child stderr stream or nil
```

## 说明

读取可赋值的标准错误槽。用 `run-program` 启动后，可在独立的管道中读取子进程诊断。空句柄的槽为 `nil`。如果两个通道都可能有大量输出，应同时读取，或使用同步捕获。

## 示例

从标准错误流读出子 shell 写入的消息。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf detail >&2"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (read-line (han.host:host-process-error-stream child) nil))
    (han.host:process-close child)))
;; => "detail"
```

将面向人的诊断与机器可读的标准输出分开。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf 12; printf warning >&2"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (list (parse-integer (read-line (han.host:host-process-output-stream child)))
               (read-line (han.host:host-process-error-stream child))))
    (han.host:process-close child)))
;; => (12 "warning")
```

[`han.host:host-process-output-stream`](host-process-output-stream.zh-CN.md) · [`han.host:run-program-sync`](run-program-sync.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
