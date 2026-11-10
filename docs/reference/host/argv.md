# `han.host:argv`

[简体中文](argv.zh-CN.md)

*Function*

## Syntax

```text
(han.host:argv &optional (keep-first nil)) → list
```

## Description

Returns the implementation's command-line argument list. The default omits the first entry (the invoked program). Pass a true value to include it. The values reflect the running image, so launch options and delivered executables may produce different lists. ECL decodes each OS argument from UTF-8 into one Lisp string. Empty arguments and long arguments containing multibyte characters retain their full contents. CCL exposes the arguments left by its kernel: for example, it consumes `--batch` and retains `--load` and the application argument separator. For a script invoked as `ecl -norc -shell script.lisp -- arg …` or `darm64cl --no-init --batch --load script.lisp -- arg …`, the application arguments follow `"--"`.

## Examples

Compare the default argument list with the list that includes the program name.

```lisp
(equal (han.host:argv) (rest (han.host:argv t)))
;; => T
```

Pass two arguments to a script, preserving the space, Han character and emoji in the first. On ECL and CCL the script reads past the interpreter’s `--` separator. The other branch demonstrates SBCL’s `--script` convention.

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

[`han.host:getenv`](getenv.md) · [`han.host:current-process-id`](current-process-id.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
