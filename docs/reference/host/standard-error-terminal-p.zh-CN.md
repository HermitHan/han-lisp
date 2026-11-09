# `han.host:standard-error-terminal-p`

[English](standard-error-terminal-p.md)

*函数*

## 语法

```text
(han.host:standard-error-terminal-p) → boolean
```

## 说明

判断操作系统文件描述符 2 是否连接终端。已重定向或关闭的描述符返回 `nil`。查询既不读写流，也不依赖 Lisp 层重新绑定的 `*error-output*`。

## 示例

重新绑定 Lisp 的错误输出流，确认终端检测结果保持不变。

```lisp
(let ((before (han.host:standard-error-terminal-p))
      (*error-output* (make-string-output-stream)))
  (eql before (han.host:standard-error-terminal-p)))
;; => T
```

父进程捕获子进程 stderr 时，选择纯文本诊断。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit (if (han.host:standard-error-terminal-p) 1 0))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:standard-input-terminal-p`](standard-input-terminal-p.zh-CN.md) · [`han.host:configure-runtime-io`](configure-runtime-io.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
