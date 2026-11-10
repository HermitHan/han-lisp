# `han.host:argv`

[English](argv.md)

*函数*

## 语法

```text
(han.host:argv &optional (keep-first nil)) → list
```

## 说明

返回当前 Lisp 实现的命令行实参列表。默认略过代表启动程序的首项，传真值保留。具体内容取决于镜像的启动方式和宿主。ECL 将操作系统传入的每个 UTF-8 实参解码为一个 Lisp 字符串。空实参保持为空，含多字节字符的长实参保留完整内容。CCL 返回内核处理后交给 Lisp 的参数，例如内核会消耗 `--batch`，保留 `--load` 及应用参数分隔符。以 `ecl -norc -shell script.lisp -- arg …` 或 `darm64cl --no-init --batch --load script.lisp -- arg …` 启动时，应用的参数位于 `"--"` 之后。

## 示例

比较默认实参列表与包含程序名的完整列表。

```lisp
(equal (han.host:argv) (rest (han.host:argv t)))
;; => T
```

给脚本传入两个实参，保留第一个实参中的空格、汉字和表情符号。ECL 和 CCL 脚本读取解释器分隔符 `--` 后的参数；另一种启动方式演示 SBCL 的 `--script` 约定。

```lisp
(uiop:with-temporary-file (:stream out :pathname script :type "lisp")
  (format out "(load ~S)~%" (asdf:system-relative-pathname "han" "load-han.lisp"))
  (write-line "(let ((args (han.host:argv)))" out)
  (write-line "  (han.host:quit (if (equal #+(or ecl ccl) (rest (member \"--\" args :test #'string=))" out)
  (write-line "                            #-(or ecl ccl) args '(\"two words 汉😀\" \"-x\")) 0 1)))" out)
  :close-stream
  (nth-value 2 (han.host:run-program-sync
                (list #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
                      #+ecl "--norc" #+ecl "--shell"
                      #+ccl "--no-init" #+ccl "--batch" #+ccl "--load"
                      #-(or ecl ccl) "--script"
                      (namestring script) #+(or ecl ccl) "--" "two words 汉😀" "-x"))))
;; => 0
```

[`han.host:getenv`](getenv.zh-CN.md) · [`han.host:current-process-id`](current-process-id.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [索引](../README.zh-CN.md)
