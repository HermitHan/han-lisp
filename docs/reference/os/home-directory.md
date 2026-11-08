# `han.os:home-directory`

*Function · 函数*

## Syntax · 语法

```text
(han.os:home-directory) → directory namestring or nil
```

## Description · 说明

Tries `HOME` first and then `user-homedir-pathname`. It checks that each candidate actually names a directory before returning the directory namestring. If neither yields an existing directory, returns `nil`.

先检查 `HOME`，再尝试 `user-homedir-pathname`。只有候选路径确实指向已有目录时才返回目录名称字符串；均不可用时返回 `nil`。

## Examples · 示例

When a home directory is available, use the returned string to look it up on disk.

能取得主目录时，用返回的字符串查询磁盘上的目录。

```lisp
(let ((home (han.os:home-directory)))
  (or (null home)
      (and (stringp home) (pathnamep (han.host:directory-exists-p home)))))
;; => T
```

Point HOME at a real scratch location in a child and verify that it is selected.

给子进程指定真实临时目录作为 HOME，验证目录选择结果。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" (format nil "HOME=~A" (namestring (uiop:temporary-directory))) "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (equal (truename (han.os:home-directory)) (truename (uiop:temporary-directory))))" "--quit")))
;; => 0
```

[`han.os:current-directory`](current-directory.md) · [`han.os:current-user`](current-user.md) · [env.lisp](../../../os/env.lisp) · [Index · 索引](../README.md)
