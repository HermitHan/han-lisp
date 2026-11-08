# `han.host:configure-runtime-io`

*Function · 函数*

## Syntax · 语法

```text
(han.host:configure-runtime-io) → t
```

## Description · 说明

Configures a CLI's live streams. LispWorks selects Unicode/UTF-8, binds standard output to descriptor 1, and directs both error and trace output to descriptor 2. On SBCL the function simply returns `t`. This example exercises the startup sequence in a separate SBCL process so the interactive image keeps its streams.

配置 CLI 运行时的输出流。LispWorks 设置 Unicode 和 UTF-8，用描述符 1 输出标准输出，用描述符 2 输出错误和 trace；SBCL 上直接返回 `t`。示例在单独的 SBCL 子进程内验证启动顺序，避免更改交互镜像的流。需要 PATH 中有 `sbcl`。

## Examples · 示例

Prepare and configure I/O in a fresh SBCL process and check its exit code.

在新的 SBCL 进程中准备并配置输入输出，然后检查退出码。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(progn (han.host:prepare-runtime-io) (assert (han.host:configure-runtime-io)))"
         "--quit")))
;; => 0
```

Capture a Unicode diagnostic from a configured child. Its stderr can be redirected without changing the parent REPL.

捕获已配置的子进程写入的 Unicode 诊断，重定向子进程的 stderr，不改动父 REPL。

```lisp
(multiple-value-bind (stdout stderr status)
    (han.host:run-program-sync
     (list "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
           "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
           "--eval" "(progn (han.host:configure-runtime-io) (write-string \"需要参数\" *error-output*) (finish-output *error-output*))"
           "--quit"))
  (declare (ignore stdout))
  (list status (not (null (search "需要参数" stderr)))))
;; => (0 T)
```

[`han.host:prepare-runtime-io`](prepare-runtime-io.md) · [`han.host:standard-error-terminal-p`](standard-error-terminal-p.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [unsupported.lisp](../../../host/unsupported.lisp) · [Index · 索引](../README.md)
