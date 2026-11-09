# `han.os:find-executable`

[English](find-executable.md)

*函数*

## 语法

```text
(han.os:find-executable program) → matching path namestring(s) or nil
```

## 说明

接受非空程序名字符串，含路径分隔符时优先直接探测；单个程序名则沿 `PATH` 和内置 Unix 目录搜索。不同匹配路径作为多个名称字符串按查找顺序返回，未找到时为 `nil`。检查的是文件存在性，匹配文件可能没有执行权限。

## 示例

用绝对路径查找 `/bin/sh`，再检查返回的字符串是否指向文件。

```lisp
(let ((found (han.os:find-executable "/bin/sh")))
  (and (stringp found) (pathnamep (han.host:file-exists-p found))))
;; => T
```

按完整路径能找到没有执行位的普通文件。这个查询本身无法验证能否启动它。

```lisp
(uiop:with-temporary-file (:pathname regular-file)
  (han.os:run-program (list "/bin/chmod" "600" (namestring regular-file)) :ignore-error-status nil)
  (let ((match (han.os:find-executable (namestring regular-file))))
    (and match (string= (namestring (truename match)) (namestring (truename regular-file))))))
;; => T
```

[`han.os:run-program`](run-program.zh-CN.md) · [`han.host:file-exists-p`](../host/file-exists-p.zh-CN.md) · [env.lisp](../../../os/env.lisp) · [索引](../README.zh-CN.md)
