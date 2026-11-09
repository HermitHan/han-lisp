# `han.os:current-directory`

[English](current-directory.md)

*函数*

## 语法

```text
(han.os:current-directory) → namestring or nil
```

## 说明

委托 `han.host:cwd` 获取当前工作目录，以路径字符串返回，无法解析时返回 `nil`。如需进行 pathname 操作，可以把字符串传给 `han.path`。

## 示例

核对当前工作目录与宿主层返回的目录是否一致。

```lisp
(equal (han.os:current-directory) (han.host:cwd))
;; => T
```

在调用方临时切换的工作目录下解析项目相对文件名。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (uiop:with-current-directory (root)
         (string= (namestring (merge-pathnames "table.tsv" (truename root)))
                  (namestring (han.path:join-path (han.os:current-directory) "table.tsv"))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

[`han.os:home-directory`](home-directory.zh-CN.md) · [`han.host:cwd`](../host/cwd.zh-CN.md) · [env.lisp](../../../os/env.lisp) · [索引](../README.zh-CN.md)
