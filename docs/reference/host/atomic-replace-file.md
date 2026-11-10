# `han.host:atomic-replace-file`

[简体中文](atomic-replace-file.zh-CN.md)

*Function*

## Syntax

```text
(han.host:atomic-replace-file source target) → t
```

## Description

Moves a prepared regular file at `source` to the exact name `target` in a single filesystem rename. Both arguments are nonempty strings of Unicode scalar characters, encoded as UTF-8. NUL is invalid. Spaces, `*` and `?` are literal filename characters. Pass the original string if you already have a Unix filename. Relative names start at the process’s current working directory. Both parent directories must already exist on the same filesystem. The target may be absent or an existing regular file.

On success, returns the single value `t`. The source directory entry disappears, and opening the target gives the source file with its contents and permission bits. If the target existed, readers opening it across the switch see the complete old or new file. Open descriptors for the old file continue to refer to it. Finish writing the staged file before calling. An application requiring durability after power loss must also synchronize the file and directory as appropriate.

A non-string argument signals `type-error`. An invalid filename or filesystem failure signals `file-error`. The operation rejects directories, symbolic links in the final component, and other non-regular files such as FIFOs. It also rejects a source and target referring to the same file, including two hard links. A directory target or a cross-filesystem rename leaves both paths intact. Callers control which existing files may be replaced and must keep other writers from swapping the entries or their parent directories during the operation.

## Examples

Publish a staged file under a new name with no extension.

```lisp
(let* ((root (uiop:run-program '("mktemp" "-d") :output :line))
       (staged (concatenate 'string root "/staged.tmp"))
       (target (concatenate 'string root "/launcher")))
  (unwind-protect
       (progn
         (han.host:append-utf8-line staged "ready")
         (list (han.host:atomic-replace-file staged target)
               (han.os:load-lines target)
               (probe-file staged)))
    (uiop:delete-directory-tree (uiop:ensure-directory-pathname root)
                                :validate t)))
;; => (T ("ready") NIL)
```

Replace existing contents while an earlier reader still holds the old file open.

```lisp
(uiop:with-temporary-file (:pathname staged)
  (uiop:with-temporary-file (:pathname journal)
    (han.host:append-utf8-line journal "prepared")
    (han.host:append-utf8-line staged "committed")
    (with-open-file (earlier-reader journal :direction :input)
      (han.host:atomic-replace-file (namestring staged) (namestring journal))
      (list (read-line earlier-reader) (han.os:load-lines journal)))))
;; => ("prepared" ("committed"))
```

Attempt to publish into a directory and read back the staged file after the error.

```lisp
(uiop:with-temporary-file (:pathname staged)
  (han.host:append-utf8-line staged "keep")
  (let ((directory (uiop:pathname-directory-pathname staged)))
    (handler-case
        (han.host:atomic-replace-file (namestring staged) (namestring directory))
      (file-error () (han.os:load-lines staged)))))
;; => ("keep")
```

[`han.host:call-with-exclusive-file-lock`](call-with-exclusive-file-lock.md) · [`han.host:copy-file`](copy-file.md) · [Source](../../../host/common.lisp) · [Index](../README.md)
