# `han.os:require-env`

[简体中文](require-env.zh-CN.md)

*Function*

## Syntax

```text
(han.os:require-env name) → environment string
```

## Description

Returns the value of the named environment variable, including an explicitly empty string. Signals an error if the variable is unset. The example handles either environment while checking the matching behavior.

On ECL, long UTF-8 values retain their full text. [Environment lookup](../host/getenv.md)

## Examples

Check the value when the variable is set and catch the error when it is missing.

```lisp
(let* ((name "HAN_MANUAL_REQUIRED_VALUE")
       (value (han.host:getenv name)))
  (if value
      (string= value (han.os:require-env name))
      (handler-case (progn (han.os:require-env name) nil)
        (error () t))))
;; => T
```

Reject an unconfigured batch job at startup. The child converts a missing environment variable into a recognizable exit status.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_DATASET" #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(handler-case (progn (han.os:require-env \"HAN_DOCS_DATASET\") (han.host:quit 0)) (error () (han.host:quit 64)))" "--eval" "(han.host:quit)")))
;; => 64
```

[`han.os:getenv-default`](getenv-default.md) · [`han.host:getenv`](../host/getenv.md) · [env.lisp](../../../os/env.lisp) · [Index](../README.md)
