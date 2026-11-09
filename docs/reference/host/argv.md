# `han.host:argv`

[简体中文](argv.zh-CN.md)

*Function*

## Syntax

```text
(han.host:argv &optional (keep-first nil)) → list
```

## Description

Returns the implementation's command-line argument list. The default omits the first entry (the invoked program). Pass a true value to include it. The values reflect the running image, so launch options and delivered executables may produce different lists. ECL exposes the OS argument vector, including its own interpreter switches. For a script invoked as `ecl -norc -shell script.lisp -- arg …`, the application arguments follow `"--"`.

## Examples

Compare the default argument list with the list that includes the program name.

```lisp
(equal (han.host:argv) (rest (han.host:argv t)))
;; => T
```

Pass two arguments to a script, preserving the space, Han character and emoji in the first. On ECL the script reads past the interpreter’s `--` separator. The other branch demonstrates SBCL’s `--script` convention.

```lisp
(uiop:with-temporary-file (:stream out :pathname script :type "lisp")
  (format out "(load ~S)~%" (asdf:system-relative-pathname "han" "load-han.lisp"))
  (write-line "(let ((args (han.host:argv)))" out)
  (write-line "  (han.host:quit (if (equal #+ecl (rest (member \"--\" args :test #'string=))" out)
  (write-line "                            #-ecl args '(\"two words 汉😀\" \"-x\")) 0 1)))" out)
  :close-stream
  (nth-value 2 (han.host:run-program-sync
                (list #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
                      #+ecl "--norc" #+ecl "--shell" #-ecl "--script"
                      (namestring script) #+ecl "--" "two words 汉😀" "-x"))))
;; => 0
```

[`han.host:getenv`](getenv.md) · [`han.host:current-process-id`](current-process-id.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
