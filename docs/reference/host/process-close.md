# `han.host:process-close`

*Function · 函数*

## Syntax · 语法

```text
(han.host:process-close process) → nil
```

## Description · 说明

Releases the local process streams and backend resources, returning `nil`. It does not request that the child be terminated. Wrap handle use in `unwind-protect` so resources are released if reading or processing output fails.

释放本地进程流和后端资源，返回 `nil`，不请求终止子进程。可用 `unwind-protect` 保护句柄的使用，使读取或处理输出时报错也会清理资源。

## Examples · 示例

Wait for a child and close its handle, then check whether its output stream is still open.

等待子进程结束并关闭句柄，再检查其输出流是否仍然打开。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (han.host:process-wait child)
    (han.host:process-close child))
  (open-stream-p (han.host:host-process-output-stream child)))
;; => NIL
```

Release the handle when parsing fails and translate a malformed response into a result the caller can handle.

工作进程输出格式错误时仍清理句柄，调用方可以返回解析失败的标记。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf invalid"))))
  (handler-case
      (unwind-protect
           (progn (han.host:process-wait child)
                  (parse-integer (read-line (han.host:host-process-output-stream child))))
        (han.host:process-close child))
    (parse-error () :invalid-number)))
;; => :INVALID-NUMBER
```

[`han.host:process-wait`](process-wait.md) · [`han.host:host-process-output-stream`](host-process-output-stream.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [Index · 索引](../README.md)
