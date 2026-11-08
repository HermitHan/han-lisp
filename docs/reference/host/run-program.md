# `han.host:run-program`

*Function · 函数*

## Syntax · 语法

```text
(han.host:run-program program &key (arguments '()) input directory environment) → host-process
```

## Description · 说明

Starts an external program asynchronously. Supply an existing executable file path and its argument strings. `directory` and `environment` are passed to the active backend only when supplied explicitly. The result owns separate stdout and stderr pipes. The caller drains them, waits for termination, and closes the handle. A missing program signals an error.

异步启动外部程序。传入已有可执行文件路径和参数字符串列表。仅当调用方显式指定时，才向后端传递 `directory` 和 `environment`。返回的句柄持有标准输出和标准错误管道，调用方负责读取、等待并关闭。程序文件不存在时报错。

## Examples · 示例

Start a shell, wait for it to finish, then read its output and exit code.

启动一个 shell，等待它结束，再读取输出和退出码。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "printf ok"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (list (read-line (han.host:host-process-output-stream child) nil)
               (han.host:process-exit-code child)))
    (han.host:process-close child)))
;; => ("ok" 0)
```

Run a tool in a caller-specified working directory while keeping the parent's directory unchanged.

在调用方选定的目录运行工具，同时保留父进程的工作目录。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let ((child (han.host:run-program "/bin/pwd" :directory root)))
         (unwind-protect
              (progn (han.host:process-wait child)
                     (equal (truename root)
                            (truename (read-line (han.host:host-process-output-stream child)))))
           (han.host:process-close child)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

Passing a missing executable path fails at launch, before a process handle is returned.

程序路径缺失时，启动阶段即触发错误，不会返回可用句柄。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:run-program (namestring (han.path:join-path file "no-program"))))
;; signals simple-error
```

[`han.host:run-program-sync`](run-program-sync.md) · [`han.host:process-wait`](process-wait.md) · [`han.host:process-close`](process-close.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [Index · 索引](../README.md)
