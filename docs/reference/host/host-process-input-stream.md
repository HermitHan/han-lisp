# `han.host:host-process-input-stream`

*Accessor · 访问器*

## Syntax · 语法

```text
(han.host:host-process-input-stream process) → input slot value or nil
```

## Description · 说明

Reads the settable input slot. SBCL records the native process's input stream when available. LispWorks stores the supplied `input` argument, so a handle may contain an input designator or `nil`. Check the value before treating it as a stream.

读取可赋值的输入槽。SBCL 记录宿主可提供的进程输入流，LispWorks 保存传给启动函数的 `input` 参数，因此结果可能是输入指示对象或 `nil`。使用流操作前可先检查返回值。

## Examples · 示例

Attach a string input stream to a handle and read one character through the accessor.

为句柄设置字符串输入流，再用访问器取得该流并读取一个字符。

```lisp
(with-input-from-string (input "x")
  (let ((handle (han.host:make-host-process :input-stream input)))
    (read-char (han.host:host-process-input-stream handle))))
;; => #\x
```

Close a writable input slot to signal end-of-input. This example exercises a pipe-like stream fixture independently of backend conventions.

输入端写完后关闭它以发送 EOF。示例使用模拟输入端的输出流，不依赖各后端对输入槽的约定。

```lisp
(let* ((input (make-string-output-stream))
       (handle (han.host:make-host-process :input-stream input))
       (port (han.host:host-process-input-stream handle)))
  (when (and (streamp port) (output-stream-p port))
    (write-line "done" port)
    (finish-output port)
    (close port))
  (open-stream-p input))
;; => NIL
```

[`han.host:run-program`](run-program.md) · [`han.host:host-process-output-stream`](host-process-output-stream.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
