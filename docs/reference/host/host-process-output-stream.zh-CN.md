# `han.host:host-process-output-stream`

[English](host-process-output-stream.md)

*访问器*

## 语法

```text
(han.host:host-process-output-stream process) → child stdout stream or nil
```

## 说明

读取可赋值的标准输出槽。使用 `run-program` 启动进程时，父进程可从该管道读取子进程的标准输出。空句柄的槽为 `nil`。子进程输出较大时，应在运行期间读取，避免管道写满。

## 示例

从标准输出流读取子 shell 写出的文字。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf stdout"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (read-line (han.host:host-process-output-stream child) nil))
    (han.host:process-close child)))
;; => "stdout"
```

在等待子进程之前，从 stdout 连续读行直到 EOF。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf 'start\\nend\\n'"))))
  (unwind-protect
       (let ((lines (han.os:load-lines (han.host:host-process-output-stream child))))
         (han.host:process-wait child)
         lines)
    (han.host:process-close child)))
;; => ("start" "end")
```

[`han.host:host-process-error-stream`](host-process-error-stream.zh-CN.md) · [`han.host:process-close`](process-close.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
