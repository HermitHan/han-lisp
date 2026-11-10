# han.path

[User guide](README.md) · [简体中文](path.zh-CN.md) · [Package symbol index](../reference/README.md#path)

Use `han.path` to build filenames, report a path relative to a project directory, or inspect a directory on disk. The examples use Unix pathname syntax. Function names below belong to `han.path`.

## Build a report path

A caller supplies a directory with or without a trailing slash. Treat it as a directory, add a year and filename, and compute the name to store in a project manifest. The target and the explicitly supplied absolute base can both be hypothetical.

```lisp
(let* ((root (han.path:directory-pathname "/work/reports"))
       (file (han.path:join-path root "2026" "summary.json")))
  (list (han.path:->namestring file)
        (han.path:->namestring (han.path:relative-path file root))
        (han.path:->namestring (han.path:parent-directory-pathname file))))
;; => ("/work/reports/2026/summary.json" "2026/summary.json" "/work/reports/2026/")
```

| Operation | Result |
| --- | --- |
| [`->pathname x`](../reference/path/to-pathname.md), [`->namestring x`](../reference/path/to-namestring.md) | Accept a string or pathname. The first returns a pathname with a normalized directory component. The second returns its namestring. A named physical file with an explicit `:unspecific` type can be rendered without an extension. If the host has no spelling, the function signals a `file-error` carrying the path in `file-error-pathname`. |
| [`directory-pathname-p x`](../reference/path/directory-pathname-p.md) | Tests pathname shape. A directory pathname has no name or type component. |
| [`directory-pathname x`](../reference/path/directory-pathname.md) | Returns a directory pathname, moving a file-like last component into the directory list. For example, `"a.txt"` becomes `"a.txt/"`. |
| [`parent-directory-pathname x`](../reference/path/parent-directory-pathname.md) | Drops the name and type of a file pathname. A directory pathname already denotes its own directory, so `"/work/reports/"` returns `#P"/work/reports/"`. |
| [`join-path base &rest parts`](../reference/path/join-path.md) | Returns a pathname. Successive components are merged against the preceding result treated as a directory. An absolute component can replace earlier components. |
| [`absolute-pathname-p x`](../reference/path/absolute-pathname-p.md) | Tests whether the directory component starts with `:absolute`. |
| [`absolute-pathname x &optional base`](../reference/path/absolute-pathname.md) | Returns an absolute input as a pathname. For a relative input, merges it against `base` treated as a directory. When a relative input needs a default base, Han uses [the Lisp working directory](../reference/host/working-directory-pathname.md). Supply an absolute base when an absolute result is required. |
| [`relative-path target &optional base`](../reference/path/relative-path.md) | Resolves each argument against the current directory, then computes the pathname from `base` to `target`, including parent steps when needed. A relative result keeps its host and device. If they differ, or a logical pathname would need a parent step, the function returns the absolute target. To interpret a relative target *inside* a specific base, call `absolute-pathname` with that base first. |

## Inspect or change files

A shape test works on a name alone. An existence check probes the filesystem and yields a pathname you can hand to another function.

```lisp
(list (han.path:directory-pathname-p "/bin/sh")
      (pathnamep (han.path:file-exists-p "/bin/sh"))
      (pathnamep (han.path:directory-exists-p "/bin")))
;; => (NIL T T)
```

| Operation | Result and effects |
| --- | --- |
| [`file-exists-p path`](../reference/path/file-exists-p.md), [`directory-exists-p path`](../reference/path/directory-exists-p.md) | Return the existing file pathname or directory pathname respectively, or `nil` if the probe yields no match. |
| [`directory-files directory`](../reference/path/directory-files.md), [`subdirectories directory`](../reference/path/subdirectories.md) | List the immediate matching files or child directories as pathnames. Sort the returned list yourself if the order matters. |
| [`copy-file source target`](../reference/path/copy-file.md) | Copies bytes, creates missing parent directories, replaces an existing target, and returns the supplied target. |
| [`delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)`](../reference/path/delete-directory-tree.md) | Recursively removes the existing directory and returns `t`. The default check rejects the filesystem root. For an absent directory, `:ignore` returns `nil` and `:error` signals an error. The implementation invokes Unix `rm`. |
| [`temporary-directory`](../reference/path/temporary-directory.md) | Returns a directory pathname from `TMPDIR`, `TEMP`, `TMP`, then `/tmp/`. Callers choose their own unique child names. |
| [`help &optional stream`](../reference/path/help.md), [`version &optional stream`](../reference/path/version.md) | Return the help text or version string and print to the supplied stream (default `*standard-output*`). Pass `nil` for just the string. |

To replace a file while readers may still have it open, stage a regular file on the target filesystem and pass the two literal filenames to the host operation. Pass existing filename strings directly. When starting with a pathname object, obtain its spelling with `han.path:->namestring`. [Atomic file replacement](../reference/host/atomic-replace-file.md)

For file locking or UTF-8 append, see [han.host](host.md). For the list of exports and pathname examples, see the [package definition](../../path/package.lisp) and [tests](../../path/test.lisp).
