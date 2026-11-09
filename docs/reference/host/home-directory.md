# `han.host:home-directory`

[简体中文](home-directory.zh-CN.md)

*Function*

## Syntax

```text
(han.host:home-directory) → directory namestring or nil
```

## Description

Looks for an existing directory at the path in `HOME`. When that lookup returns `nil`, tries `user-homedir-pathname`. Returns the namestring of the first directory found, or `nil` if both lookups fail.

## Examples

When a home directory is available, turn the returned string back into an existing directory pathname.

```lisp
(let ((home (han.host:home-directory)))
  (or (null home) (pathnamep (han.host:directory-exists-p home))))
;; => T
```

Build a settings pathname under the home directory, using the temporary directory when the home directory is unavailable.

```lisp
(let* ((directory (or (han.host:home-directory) (han.host:temporary-directory)))
       (settings (merge-pathnames "settings.json" directory)))
  (list (file-namestring settings)
        (equal (pathname-directory settings) (pathname-directory directory))))
;; => ("settings.json" T)
```

[`han.host:directory-exists-p`](directory-exists-p.md) · [`han.os:home-directory`](../os/home-directory.md) · [common.lisp](../../../host/common.lisp) · [Index](../README.md)
