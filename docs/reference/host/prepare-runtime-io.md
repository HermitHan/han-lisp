# `han.host:prepare-runtime-io`

[简体中文](prepare-runtime-io.zh-CN.md)

*Macro*

## Syntax

```text
(han.host:prepare-runtime-io) → t
```

## Description

A macro for executable entry points. On LispWorks its expansion sets the default character element type to `character` and the console encoding to UTF-8. It expands to `t` on SBCL, ECL and CCL. Call it before configuring runtime streams. The example inspects the macro expansion without changing the current REPL's I/O.

## Examples

Use macro expansion to inspect a preparation call without executing it.

```lisp
(not (null (nth-value 1 (macroexpand-1 '(han.host:prepare-runtime-io)))))
;; => T
```

Prepare a child Lisp process’s I/O in a separate image and produce a Unicode character string after preparation.

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

[`han.host:configure-runtime-io`](configure-runtime-io.md) · [`han.host:with-character-output-to-string`](with-character-output-to-string.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
