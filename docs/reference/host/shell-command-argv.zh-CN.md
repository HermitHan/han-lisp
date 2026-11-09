# `han.host:shell-command-argv`

[English](shell-command-argv.md)

*函数*

## 语法

```text
(han.host:shell-command-argv command &optional shell) → list
```

## 说明

构造供后续进程调用使用的列表 `(shell-path "-c" command)`。省略 shell 时优先查找 `bash`，找不到再查找 `sh`。显式指定 shell 时直接探测该文件，并在结果中保留传入的路径。找不到默认 shell 或指定文件不存在时发出错误。整段命令文本作为一个参数传给 shell。

## 示例

显式指定 shell，在启动进程前查看参数。

```lisp
(han.host:shell-command-argv "printf '%s' 'a b'" "/bin/sh")
;; => ("/bin/sh" "-c" "printf '%s' 'a b'")
```

使用默认 shell 运行命令，取得输出和退出码。

```lisp
(han.host:run-program-sync
 (han.host:shell-command-argv "printf '%s' 'a b'"))
;; => values ("a b" "" 0)
```

[`han.os:run-shell-command`](../os/run-shell-command.zh-CN.md) · [`han.host:run-program-sync`](run-program-sync.zh-CN.md) · [common.lisp](../../../host/common.lisp) · [索引](../README.zh-CN.md)
