# `han.host:current-user`

[简体中文](current-user.zh-CN.md)

*Function*

## Syntax

```text
(han.host:current-user) → string or nil
```

## Description

Reads `USER` and then `LOGNAME` from the process environment. Returns the first value found, including an empty string. Returns `nil` when both variables are unset. Applications can supply a display name through `han.os:current-user`.

## Examples

Read the user name with an application-specific fallback for a batch job.

```lisp
(equal (or (han.host:current-user) "batch")
       (han.os:current-user "batch"))
;; => T
```

Start a child Lisp process with different account labels and check which one it reports.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "USER=builder" "LOGNAME=login" #+(or ecl ccl) (first (han.host:argv t)) #-(or ecl ccl) (han.host:find-executable "sbcl")
         #+ecl "--norc" #+ccl "--no-init" #-(or ecl ccl) "--no-userinit"
         #+ecl "--nodebug" #+ccl "--batch" #-(or ecl ccl) "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (han.host:current-user) \"builder\"))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:getenv`](getenv.md) · [`han.os:current-user`](../os/current-user.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
