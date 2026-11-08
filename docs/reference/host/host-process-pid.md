# `han.host:host-process-pid`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.host:host-process-pid process) → child PID or nil
```

## Description · 说明

Reads the `pid` slot of a `host-process`. A live adapter fills it with the child's process identifier when available. The generated accessor supports `setf`. A structure created without a PID returns `nil`.

读取 `host-process` 的 PID 槽，宿主能提供时会在启动后填入子进程 PID。生成的访问器支持 `setf`，构造时未指定 PID 则返回 `nil`。

## Examples · 示例

Read the process ID stored in a manually constructed handle.

从手工构造的句柄中读取已保存的进程号。

```lisp
(let ((handle (han.host:make-host-process :pid 23)))
  (han.host:host-process-pid handle))
;; => 23
```

Match a shell's self-reported process ID to the child handle.

用 shell 自己报告的 PID 与父进程持有的句柄核对。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf '%s' \"$$\""))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (= (parse-integer (read-line (han.host:host-process-output-stream child)))
            (han.host:host-process-pid child)))
    (han.host:process-close child)))
;; => T
```

[`han.host:current-process-id`](current-process-id.md) · [`han.host:host-process`](host-process.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
