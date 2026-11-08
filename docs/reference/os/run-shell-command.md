# `han.os:run-shell-command`

*Function · 函数*

## Syntax · 语法

```text
(han.os:run-shell-command command &key (wait t) (lines t) shell) → stdout, stderr, status (and a handle in asynchronous mode)
```

## Description · 说明

Executes shell text using `-c` with the supplied shell pathname, or searches for `bash` and then `sh`. By default it waits and returns stdout and stderr as line lists plus the exit code. `:lines nil` preserves output as strings. With `:wait nil` it returns the two readable pipes, `nil` and a child handle. The caller drains the pipes, waits, inspects the exit code and closes the handle. An invalid shell path signals an error.

通过指定 shell 路径的 `-c` 运行文本，未指定时先找 `bash` 再找 `sh`。默认等待结束，返回 stdout 行列表、stderr 行列表和退出码。`:lines nil` 时保留为字符串。`:wait nil` 时返回两个可读管道、占位 `nil` 和子进程句柄，调用方负责读管道、等待、取退出码及关闭。指定的 shell 路径不存在时触发错误。

## Examples · 示例

Write to both output streams and collect each stream together with the nonzero exit code.

让 shell 分别写入标准输出和标准错误，再取回两组输出以及非零退出码。

```lisp
(multiple-value-list
 (han.os:run-shell-command "printf ok; printf note >&2; exit 5"
                           :shell "/bin/sh"))
;; => (("ok") ("note") 5)
```

Capture raw strings with their terminating newlines for a text protocol.

按字符串捕获标准输出和标准错误，保留文本协议中的末尾换行。

```lisp
(multiple-value-bind (out err code)
    (han.os:run-shell-command "printf 'ok\\n'; printf 'note\\n' >&2"
                              :shell "/bin/sh" :lines nil)
  (list (string= out (format nil "ok~%")) (string= err (format nil "note~%")) code))
;; => (T T 0)
```

Consume asynchronous stdout and stderr and obtain the actual exit status from the handle.

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

[`han.os:escape-sh-token`](escape-sh-token.md) · [`han.os:run-program`](run-program.md) · [`han.host:process-wait`](../host/process-wait.md) · [run-shell.lisp](../../../os/run-shell.lisp) · [Index · 索引](../README.md)
