# `han.os:getenv-default`

[简体中文](getenv-default.zh-CN.md)

*Function*

## Syntax

```text
(han.os:getenv-default name default) → environment string or default
```

## Description

Looks up an environment variable by name. Returns its string value if set, including the empty string, or the supplied fallback object if unset. The fallback need not be a string.

## Examples

Use the current environment setting when present and return the keyword `:missing` when it is unset.

```lisp
(let ((name "HAN_MANUAL_OPTIONAL_VALUE"))
  (equal (han.os:getenv-default name :missing)
         (or (han.host:getenv name) :missing)))
;; => T
```

Preserve an intentionally empty setting while using a non-string default for a missing one.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_OPTION" "HAN_DOCS_TAG=" #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (list (han.os:getenv-default \"HAN_DOCS_OPTION\" :auto) (han.os:getenv-default \"HAN_DOCS_TAG\" :auto)) '(:auto \"\")))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.os:require-env`](require-env.md) · [`han.host:getenv`](../host/getenv.md) · [env.lisp](../../../os/env.lisp) · [Index](../README.md)
