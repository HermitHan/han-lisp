# `han.host:home-directory`

[English](home-directory.md)

*函数*

## 语法

```text
(han.host:home-directory) → directory namestring or nil
```

## 说明

先检查环境变量 `HOME` 指定的路径是否为已有目录。查询结果为 `nil` 时，再尝试 `user-homedir-pathname`。返回首个找到的目录名称字符串，两次都找不到则返回 `nil`。

## 示例

有主目录时，用返回的字符串取回已有目录的路径名。

```lisp
(let ((home (han.host:home-directory)))
  (or (null home) (pathnamep (han.host:directory-exists-p home))))
;; => T
```

在主目录下构造设置文件路径，主目录不可用时使用临时目录。

```lisp
(let* ((directory (or (han.host:home-directory) (han.host:temporary-directory)))
       (settings (merge-pathnames "settings.json" directory)))
  (list (file-namestring settings)
        (equal (pathname-directory settings) (pathname-directory directory))))
;; => ("settings.json" T)
```

[`han.host:directory-exists-p`](directory-exists-p.zh-CN.md) · [`han.os:home-directory`](../os/home-directory.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
