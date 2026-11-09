# `han.host:find-executable`

[简体中文](find-executable.zh-CN.md)

*Function*

## Syntax

```text
(han.host:find-executable program) → matching namestring(s) or nil
```

## Description

Accepts a nonempty string. If it contains a slash or backslash, checks that path first and returns its namestring immediately on a hit. If the direct lookup misses or the name has no separator, searches the colon-separated `PATH` in order. An empty entry denotes the current directory. The search then continues through `/usr/local/bin`, `/usr/bin`, `/bin`, `/usr/sbin`, `/sbin`, `/opt/homebrew/bin`, and `/opt/local/bin`. Each distinct file namestring is returned as a separate value. An invalid input or a miss returns `nil`. The lookup checks file existence alone. Execute permission is determined when a process actually starts.

## Examples

Collect all matches for the system shell. The first element is the path an ordinary single-value call returns.

```lisp
(let ((paths (multiple-value-list (han.host:find-executable "sh"))))
  (and (every #'stringp paths)
       (equal paths (remove-duplicates paths :test #'string=))
       (equal (first paths) (han.host:find-executable "sh"))))
;; => T
```

Look up a temporary regular file directly. The call returns exactly one value.

```lisp
(uiop:with-temporary-file (:pathname file)
  (equal (multiple-value-list (han.host:find-executable (namestring file)))
         (list (namestring (truename file)))))
;; => T
```

An empty program name has no match.

```lisp
(han.host:find-executable "")
;; => values (NIL)
```

[`han.os:find-executable`](../os/find-executable.md) · [`han.host:shell-command-argv`](shell-command-argv.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
