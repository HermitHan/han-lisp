# `han.host:prepare-runtime-io`

*Macro · 宏*

## Syntax · 语法

```text
(han.host:prepare-runtime-io) → t
```

## Description · 说明

A macro for executable entry points. On LispWorks its expansion sets the default character element type to `character` and the console encoding to UTF-8. It expands to `t` on SBCL. Call it before configuring runtime streams. The example inspects the macro expansion without changing the current REPL's I/O.

在可执行程序入口调用的宏。LispWorks 上展开为设置默认字符元素类型及 UTF-8 控制台编码的代码，SBCL 上展开为 `t`。应先准备，再配置运行流。示例只检查宏展开，保留当前 REPL 的 I/O 设置。

## Examples · 示例

Use macro expansion to inspect a preparation call without executing it.

使用宏展开检查准备输入输出的调用，无需求值。

```lisp
(nth-value 1 (macroexpand-1 '(han.host:prepare-runtime-io)))
;; => T
```

Prepare an SBCL command's I/O in a separate image and produce a Unicode character string after preparation.

在单独的 SBCL 镜像中调用准备宏，再验证程序能生成非 ASCII 字符串。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(progn (han.host:prepare-runtime-io) (assert (string= \"读\" (han.host:with-character-output-to-string (s) (write-char (code-char #x8BFB) s)))))" "--quit")))
;; => 0
```

[`han.host:configure-runtime-io`](configure-runtime-io.md) · [`han.host:with-character-output-to-string`](with-character-output-to-string.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index · 索引](../README.md)
