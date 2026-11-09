# `han.host:process-wait`

[English](process-wait.md)

*函数*

## 语法

```text
(han.host:process-wait process) → the same host-process
```

## 说明

阻塞等待子进程结束，返回传入的同一个句柄。退出码可随后单独读取。子进程若写满管道会在退出前阻塞，有大量输出时应边运行边读取两路输出，或使用同步捕获。

## 示例

等待子进程结束，确认返回的对象就是原来的句柄。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (eq child (han.host:process-wait child))
    (han.host:process-close child)))
;; => T
```

从输出管道读到 EOF 后等待子进程，取回最终退出码。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf scanned; exit 6"))))
  (unwind-protect
       (let ((result (han.os:load-string (han.host:host-process-output-stream child))))
         (han.host:process-wait child)
         (list result (han.host:process-exit-code child)))
    (han.host:process-close child)))
;; => ("scanned" 6)
```

[`han.host:process-exit-code`](process-exit-code.zh-CN.md) · [`han.host:process-close`](process-close.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [索引](../README.zh-CN.md)
