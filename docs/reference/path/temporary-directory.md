# `han.path:temporary-directory`

[简体中文](temporary-directory.zh-CN.md)

*Function*

## Syntax

```text
(han.path:temporary-directory) → directory-pathname
```

## Description

Returns a directory pathname chosen from the environment in order: `TMPDIR`, `TEMP`, `TMP`, then `/tmp/`. The caller chooses a fresh child name for each temporary file. This function does not create a directory.

## Examples

Check that the temporary directory is returned as a directory pathname.

```lisp
(han.path:directory-pathname-p (han.path:temporary-directory))
;; => T
```

Build an absolute scratch filename underneath the selected temporary root without creating it.

```lisp
(let* ((dir (han.path:absolute-pathname (han.path:temporary-directory)))
       (output (han.path:join-path dir "stage" "table.tsv")))
  (han.path:->namestring (han.path:relative-path output dir)))
;; => "stage/table.tsv"
```

Reserve a file under the chosen directory and verify the filesystem location.

```lisp
(uiop:with-temporary-file (:directory (han.path:temporary-directory) :pathname file)
  (string= (namestring (truename (han.path:parent-directory-pathname file)))
           (namestring (truename (han.path:temporary-directory)))))
;; => T
```

[`han.path:directory-pathname`](directory-pathname.md) · [`han.path:join-path`](join-path.md) · [`han.host:temporary-directory`](../host/temporary-directory.md) · [Source](../../../path/core.lisp) · [Index](../README.md)
