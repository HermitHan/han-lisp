# `han.host:configure-runtime-io`

[English](configure-runtime-io.md)

*函数*

## 语法

```text
(han.host:configure-runtime-io) → t
```

## 说明

配置 CLI 运行时的输出流。LispWorks 设置 Unicode 和 UTF-8，用描述符 1 输出标准输出，用描述符 2 输出错误和 trace。SBCL 和 ECL 返回 `t`，保留原有流。示例在子进程内配置输入输出，父进程可继续交互。

## 示例

在新的 Lisp 进程中准备并配置输入输出，然后检查退出码。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(progn (han.host:prepare-runtime-io) (assert (han.host:configure-runtime-io)))"
         "--eval" "(han.host:quit)")))
;; => 0
```

让子进程向 stderr 写出 U+8BFB（读），重定向到新文件，再按 UTF-8 读取。传给解释器的求值参数只用 ASCII，读取文件时显式指定编码，避免依赖启动器对选项的解码方式和父进程的默认文本编码。

```lisp
(let ((root (uiop:ensure-directory-pathname
             (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let* ((file (merge-pathnames "diagnostic" root))
              (code (nth-value 2
                      (han.host:run-program-sync
                       (list #+ecl (first (han.host:argv t))
                             #-ecl (han.host:find-executable "sbcl")
                             #+ecl "--norc" #-ecl "--no-userinit"
                             #+ecl "--nodebug" #-ecl "--non-interactive"
                             "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
                             "--eval" "(progn (han.host:configure-runtime-io) (format *error-output* \"~&han-probe=~C~%\" (code-char #x8BFB)) (finish-output *error-output*))"
                             "--eval" "(han.host:quit)")
                       :error-output file))))
         (list code (not (null (member "han-probe=读" (han.os:load-lines file)
                                       :test #'string=)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (0 T)
```

[`han.host:prepare-runtime-io`](prepare-runtime-io.zh-CN.md) · [`han.host:standard-error-terminal-p`](standard-error-terminal-p.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
