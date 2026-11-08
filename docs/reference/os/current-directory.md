# `han.os:current-directory`

*Function · 函数*

## Syntax · 语法

```text
(han.os:current-directory) → namestring or nil
```

## Description · 说明

Returns the current working directory as a namestring by delegating to `han.host:cwd`. Returns `nil` when the current directory cannot be resolved. For pathname operations pass the resulting string to `han.path`.

委托 `han.host:cwd` 获取当前工作目录，以路径字符串返回，无法解析时返回 `nil`。如需进行 pathname 操作，可以把字符串传给 `han.path`。

## Examples · 示例

Compare the current working directory with the value reported by the host.

核对当前工作目录与宿主层返回的目录是否一致。

```lisp
(equal (han.os:current-directory) (han.host:cwd))
;; => T
```

Resolve a project-relative filename under an explicitly scoped working directory.

在调用方临时切换的工作目录下解析项目相对文件名。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-current-directory (root)
         (equal (merge-pathnames "table.tsv" (truename root))
                (han.path:join-path (han.os:current-directory) "table.tsv")))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.os:home-directory`](home-directory.md) · [`han.host:cwd`](../host/cwd.md) · [env.lisp](../../../os/env.lisp) · [Index · 索引](../README.md)
