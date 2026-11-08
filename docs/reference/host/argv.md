# `han.host:argv`

*Function · 函数*

## Syntax · 语法

```text
(han.host:argv &optional (keep-first nil)) → list
```

## Description · 说明

Returns the implementation's command-line argument list. The default omits the first entry (the invoked program). Pass a true value to include it. The values reflect the running image, so launch options and delivered executables may produce different lists.

返回当前 Lisp 实现的命令行实参列表。默认略过代表启动程序的首项，传真值保留。具体内容取决于镜像的启动方式和宿主。

## Examples · 示例

Compare the default argument list with the list that includes the program name.

比较默认实参列表与包含程序名的完整列表。

```lisp
(equal (han.host:argv) (rest (han.host:argv t)))
;; => T
```

Launch an SBCL script with two arguments, one containing a space, and check what its entry point receives.

通过 SBCL 启动临时脚本，传入两个实参，检查带空格的实参是否完整。

```lisp
(uiop:with-temporary-file (:stream out :pathname script :type "lisp")
  (format out "(load ~S)~%" (asdf:system-relative-pathname "han" "load-han.lisp"))
  (write-line "(han.host:quit (if (equal (han.host:argv) '(\"two words\" \"-x\")) 0 1))" out)
  :close-stream
  (nth-value 2 (han.host:run-program-sync
                (list "sbcl" "--script" (namestring script) "two words" "-x"))))
;; => 0
```

[`han.host:getenv`](getenv.md) · [`han.host:current-process-id`](current-process-id.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index · 索引](../README.md)
