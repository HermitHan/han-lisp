# `han.host:home-directory`

*Function · 函数*

## Syntax · 语法

```text
(han.host:home-directory) → directory namestring or nil
```

## Description · 说明

Looks for an existing directory at the path in `HOME`. When that lookup returns `nil`, tries `user-homedir-pathname`. Returns the namestring of the first directory found, or `nil` if both lookups fail.

先检查环境变量 `HOME` 指定的路径是否为已有目录。查询结果为 `nil` 时，再尝试 `user-homedir-pathname`。返回首个找到的目录名称字符串，两次都找不到则返回 `nil`。

## Examples · 示例

When a home directory is available, turn the returned string back into an existing directory pathname.

有主目录时，用返回的字符串取回已有目录的路径名。

```lisp
(let ((home (han.host:home-directory)))
  (or (null home) (pathnamep (han.host:directory-exists-p home))))
;; => T
```

Build a settings pathname under the home directory, using the temporary directory when the home directory is unavailable.

在主目录下构造设置文件路径，主目录不可用时使用临时目录。

```lisp
(let* ((directory (or (han.host:home-directory) (han.host:temporary-directory)))
       (settings (merge-pathnames "settings.json" directory)))
  (list (file-namestring settings)
        (equal (pathname-directory settings) (pathname-directory directory))))
;; => ("settings.json" T)
```

[`han.host:directory-exists-p`](directory-exists-p.md) · [`han.os:home-directory`](../os/home-directory.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
