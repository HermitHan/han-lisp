# `han.os:home-directory`

[简体中文](home-directory.zh-CN.md)

*Function*

## Syntax

```text
(han.os:home-directory) → directory namestring or nil
```

## Description

Tries `HOME` first and then `user-homedir-pathname`. It checks that each candidate actually names a directory before returning the directory namestring. If neither yields an existing directory, returns `nil`.

## Examples

When a home directory is available, use the returned string to look it up on disk.

```lisp
(let ((home (han.os:home-directory)))
  (or (null home)
      (and (stringp home) (pathnamep (han.host:directory-exists-p home)))))
;; => T
```

Point HOME at a real scratch location in a child and verify that it is selected.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" (format nil "HOME=~A" (namestring (uiop:temporary-directory))) #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (string= (namestring (truename (han.os:home-directory))) (namestring (truename (uiop:temporary-directory)))))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.os:current-directory`](current-directory.md) · [`han.os:current-user`](current-user.md) · [env.lisp](../../../os/env.lisp) · [Index](../README.md)
