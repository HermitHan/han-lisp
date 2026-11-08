# `han.host:host-process-output-stream`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.host:host-process-output-stream process) → child stdout stream or nil
```

## Description · 说明

Reads the settable stdout slot. With `run-program` the parent reads the child's standard output from this pipe. A newly constructed empty handle has no stream. Consume large outputs while the child runs to keep its pipe from filling.

读取可赋值的标准输出槽。使用 `run-program` 启动进程时，父进程可从该管道读取子进程的标准输出。空句柄的槽为 `nil`。子进程输出较大时，应在运行期间读取，避免管道写满。

## Examples · 示例

Read the text written to standard output by a child shell.

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

Read several lines from stdout up to EOF before waiting for the child.

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

[`han.host:host-process-error-stream`](host-process-error-stream.md) · [`han.host:process-close`](process-close.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
