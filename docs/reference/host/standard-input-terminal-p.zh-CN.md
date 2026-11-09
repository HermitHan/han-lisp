# `han.host:standard-input-terminal-p`

[English](standard-input-terminal-p.md)

*函数*

## 语法

```text
(han.host:standard-input-terminal-p) → boolean
```

## 说明

检查操作系统文件描述符 0 是否连接终端，不读取输入。重新绑定 `*standard-input*` 不会改变操作系统描述符，因此示例在终端及输入重定向时都可运行。

## 示例

把 Lisp 的标准输入绑定到字符串输入流，确认终端检测结果保持不变。

```lisp
(let ((before (han.host:standard-input-terminal-p)))
  (with-input-from-string (*standard-input* "")
    (eql before (han.host:standard-input-terminal-p))))
;; => T
```

在以重定向 stdin 启动的 Lisp 子进程中判断是否应使用批处理模式。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(han.host:quit (if (han.host:standard-input-terminal-p) 1 0))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:standard-error-terminal-p`](standard-error-terminal-p.zh-CN.md) · [`han.host:configure-runtime-io`](configure-runtime-io.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
