# `han.host:temporary-directory`

[简体中文](temporary-directory.zh-CN.md)

*Function*

## Syntax

```text
(han.host:temporary-directory) → directory pathname
```

## Description

Selects the first available environment value among `TMPDIR`, `TEMP`, and `TMP`, falling back to `/tmp/`. Returns the selected path in directory form. This operation neither creates a directory nor reserves a unique name or verifies writability.

## Examples

Check that the temporary directory is represented by a directory pathname.

```lisp
(han.path:directory-pathname-p (han.host:temporary-directory))
;; => T
```

Reserve a scratch file in Han's selected directory and remove it automatically at the end of the operation.

```lisp
(uiop:with-temporary-file (:directory (han.host:temporary-directory) :pathname scratch)
  (let ((parent (han.path:parent-directory-pathname scratch)))
    (string= (namestring (truename parent))
             (namestring (truename (han.host:temporary-directory))))))
;; => T
```

Check the directory Han selects when TMPDIR, TEMP, and TMP are all absent.

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "TMPDIR" "-u" "TEMP" "-u" "TMP" #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (string= \"/tmp/\" (namestring (han.host:temporary-directory))))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.host:getenv`](getenv.md) · [`han.host:directory-exists-p`](directory-exists-p.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
