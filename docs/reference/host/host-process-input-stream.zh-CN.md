# `han.host:host-process-input-stream`

[English](host-process-input-stream.md)

*访问器*

## 语法

```text
(han.host:host-process-input-stream process) → input slot value or nil
```

## 说明

读取可赋值的输入槽。SBCL 记录宿主可提供的进程输入流，在 ECL 和 CCL 上传入 `:input :stream` 会得到通往子进程的可写管道，其他输入方式下此槽为 `nil`。LispWorks 保存传给启动函数的 `input` 参数，因此结果可能是输入指示对象或 `nil`。使用流操作前可先检查返回值。

## 示例

为句柄设置字符串输入流，再用访问器取得该流并读取一个字符。

```lisp
(with-input-from-string (input "x")
  (let ((handle (han.host:make-host-process :input-stream input)))
    (read-char (han.host:host-process-input-stream handle))))
;; => #\x
```

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

[`han.host:run-program`](run-program.zh-CN.md) · [`han.host:host-process-output-stream`](host-process-output-stream.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
