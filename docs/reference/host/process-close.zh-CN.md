# `han.host:process-close`

[English](process-close.md)

*函数*

## 语法

```text
(han.host:process-close process) → nil
```

## 说明

释放本地进程流和后端资源，返回 `nil`，不请求终止子进程。可用 `unwind-protect` 保护句柄的使用，使读取或处理输出时报错也会清理资源。

## 示例

等待子进程结束并关闭句柄，再检查其输出流是否仍然打开。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (han.host:process-wait child)
    (han.host:process-close child))
  (open-stream-p (han.host:host-process-output-stream child)))
;; => NIL
```

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

[`han.host:process-wait`](process-wait.zh-CN.md) · [`han.host:host-process-output-stream`](host-process-output-stream.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [索引](../README.zh-CN.md)
