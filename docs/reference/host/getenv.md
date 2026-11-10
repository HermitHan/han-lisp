# `han.host:getenv`

[简体中文](getenv.zh-CN.md)

*Function*

## Syntax

```text
(han.host:getenv name) → string or nil
```

## Description

Looks up the named environment variable in the running process. An unset variable yields `nil`. An explicitly empty value remains the empty string. Use a string for `name`. On ECL, names and values use UTF-8. Long values containing multibyte characters are returned in full.

## Examples

Read `HOME` and allow for an environment where it has not been set.

```lisp
(let ((value (han.host:getenv "HOME")))
  (or (null value) (stringp value)))
;; => T
```

Distinguish an explicitly empty configuration variable from an unset one in a child Lisp process.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_ABSENT" "HAN_DOCS_EMPTY=" #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (list (han.host:getenv \"HAN_DOCS_EMPTY\") (han.host:getenv \"HAN_DOCS_ABSENT\")) '(\"\" nil)))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.os:getenv-default`](../os/getenv-default.md) · [`han.os:require-env`](../os/require-env.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index](../README.md)
