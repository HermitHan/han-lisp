# `han.os:find-executable`

[简体中文](find-executable.zh-CN.md)

*Function*

## Syntax

```text
(han.os:find-executable program) → matching path namestring(s) or nil
```

## Description

Accepts a nonempty program name string. A string containing a path separator is tried directly. For a bare name it searches the current `PATH` and built-in Unix fallback directories. Returns distinct matching file namestrings as multiple values, first match first, or `nil` if nothing was found. It tests file existence, so a match may lack executable permission.

## Examples

Look up `/bin/sh` by its absolute path and check that the result names a file.

```lisp
(let ((found (han.os:find-executable "/bin/sh")))
  (and (stringp found) (pathnamep (han.host:file-exists-p found))))
;; => T
```

Discover a file specified by a full path even when the regular file has no execute bit. The lookup alone cannot validate launchability.

```lisp
(uiop:with-temporary-file (:pathname regular-file)
  (han.os:run-program (list "/bin/chmod" "600" (namestring regular-file)) :ignore-error-status nil)
  (let ((match (han.os:find-executable (namestring regular-file))))
    (and match (string= (namestring (truename match)) (namestring (truename regular-file))))))
;; => T
```

[`han.os:run-program`](run-program.md) · [`han.host:file-exists-p`](../host/file-exists-p.md) · [env.lisp](../../../os/env.lisp) · [Index](../README.md)
