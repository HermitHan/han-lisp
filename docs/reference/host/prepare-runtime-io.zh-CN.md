# `han.host:prepare-runtime-io`

[English](prepare-runtime-io.md)

*宏*

## 语法

```text
(han.host:prepare-runtime-io) → t
```

## 说明

在可执行程序入口调用的宏。LispWorks 上展开为设置默认字符元素类型及 UTF-8 控制台编码的代码，SBCL、ECL 和 CCL 上展开为 `t`。应先准备，再配置运行流。示例只检查宏展开，保留当前 REPL 的 I/O 设置。

## 示例

使用宏展开检查准备输入输出的调用，无需求值。

```lisp
(not (null (nth-value 1 (macroexpand-1 '(han.host:prepare-runtime-io)))))
;; => T
```

在单独的 Lisp 镜像中调用准备宏，再验证程序能生成非 ASCII 字符串。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(progn (han.host:prepare-runtime-io) (assert (equal (map 'list #'char-code (han.host:with-character-output-to-string (s) (write-char (code-char #x8BFB) s))) '(#x8BFB))))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:configure-runtime-io`](configure-runtime-io.zh-CN.md) · [`han.host:with-character-output-to-string`](with-character-output-to-string.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
