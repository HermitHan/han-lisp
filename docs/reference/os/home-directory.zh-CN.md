# `han.os:home-directory`

[English](home-directory.md)

*函数*

## 语法

```text
(han.os:home-directory) → directory namestring or nil
```

## 说明

先检查 `HOME`，再尝试 `user-homedir-pathname`。只有候选路径确实指向已有目录时才返回目录名称字符串；均不可用时返回 `nil`。

## 示例

能取得主目录时，用返回的字符串查询磁盘上的目录。

```lisp
(let ((home (han.os:home-directory)))
  (or (null home)
      (and (stringp home) (pathnamep (han.host:directory-exists-p home)))))
;; => T
```

给子进程指定真实临时目录作为 HOME，验证目录选择结果。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" (format nil "HOME=~A" (namestring (uiop:temporary-directory))) #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(assert (string= (namestring (truename (han.os:home-directory))) (namestring (truename (uiop:temporary-directory)))))" "--eval" "(han.host:quit)")))
;; => 0
```

[`han.os:current-directory`](current-directory.zh-CN.md) · [`han.os:current-user`](current-user.zh-CN.md) · [env.lisp](../../../os/env.lisp) · [索引](../README.zh-CN.md)
