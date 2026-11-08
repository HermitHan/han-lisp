# `han.host:standard-error-terminal-p`

*Function · 函数*

## Syntax · 语法

```text
(han.host:standard-error-terminal-p) → boolean
```

## Description · 说明

Returns true when OS file descriptor 2 is attached to a terminal. A redirected or closed descriptor yields `nil`. The query ignores a rebound `*error-output*` and performs no stream reads or writes.

判断操作系统文件描述符 2 是否连接终端。已重定向或关闭的描述符返回 `nil`。查询既不读写流，也不依赖 Lisp 层重新绑定的 `*error-output*`。

## Examples · 示例

Check that rebinding the Lisp error stream leaves the terminal check unchanged.

重新绑定 Lisp 的错误输出流，确认终端检测结果保持不变。

```lisp
(let ((before (han.host:standard-error-terminal-p))
      (*error-output* (make-string-output-stream)))
  (eql before (han.host:standard-error-terminal-p)))
;; => T
```

Choose plain diagnostics when the child's stderr is captured by the parent.

父进程捕获子进程 stderr 时，选择纯文本诊断。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit (if (han.host:standard-error-terminal-p) 1 0))" "--quit")))
;; => 0
```

[`han.host:standard-input-terminal-p`](standard-input-terminal-p.md) · [`han.host:configure-runtime-io`](configure-runtime-io.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index · 索引](../README.md)
