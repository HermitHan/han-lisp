# `han.os:run-shell-command`

[English](run-shell-command.md)

*函数*

## 语法

```text
(han.os:run-shell-command command &key (wait t) (lines t) shell) → stdout, stderr, status (and a handle in asynchronous mode)
```

## 说明

通过指定 shell 路径的 `-c` 运行文本，未指定时先找 `bash` 再找 `sh`。默认等待结束，返回 stdout 行列表、stderr 行列表和退出码。`:lines nil` 时保留为字符串。`:wait nil` 时返回两个可读管道、占位 `nil` 和子进程句柄，调用方负责读管道、等待、取退出码及关闭。指定的 shell 路径不存在时触发错误。

## 示例

让 shell 分别写入标准输出和标准错误，再取回两组输出以及非零退出码。

```lisp
(multiple-value-list
 (han.os:run-shell-command "printf ok; printf note >&2; exit 5"
                           :shell "/bin/sh"))
;; => (("ok") ("note") 5)
```

按字符串捕获标准输出和标准错误，保留文本协议中的末尾换行。

```lisp
(multiple-value-bind (out err code)
    (han.os:run-shell-command "printf 'ok\\n'; printf 'note\\n' >&2"
                              :shell "/bin/sh" :lines nil)
  (list (string= out (format nil "ok~%")) (string= err (format nil "note~%")) code))
;; => (T T 0)
```

读取异步进程的两个输出流，从句柄获取实际退出状态。

```lisp
(multiple-value-bind (out err initial child)
    (han.os:run-shell-command "printf ok; printf detail >&2; exit 2"
                              :shell "/bin/sh" :wait nil)
  (unwind-protect
       (let ((line (read-line out nil)) (note (read-line err nil)))
         (han.host:process-wait child)
         (list line note initial (han.host:process-exit-code child)))
    (han.host:process-close child)))
;; => ("ok" "detail" NIL 2)
```

[`han.os:escape-sh-token`](escape-sh-token.zh-CN.md) · [`han.os:run-program`](run-program.zh-CN.md) · [`han.host:process-wait`](../host/process-wait.zh-CN.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [索引](../README.zh-CN.md)
