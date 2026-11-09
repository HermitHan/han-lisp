# `han.host:run-program`

[English](run-program.md)

*函数*

## 语法

```text
(han.host:run-program program &key (arguments '()) input directory environment) → host-process
```

## 说明

异步启动外部程序。传入已有可执行文件路径和参数字符串列表。用 `directory` 指定已有目录，子进程在该目录中启动，父进程保留原工作目录。参数中的空格和 shell 特殊字符均按原样传递。返回的句柄持有标准输出和标准错误管道，调用方负责读取、等待并关闭。程序文件不存在时报错。

省略 `environment` 时继承父进程环境。在 SBCL 和 ECL 上，显式传入 `'("MODE=fast")` 这样的字符串列表会替换整份环境，传 `:environment nil` 会得到空环境。LispWorks 接受 `'(("MODE" . "fast"))` 这样的关联表，在继承的环境中添加或覆盖变量；显式传 `nil` 仍继承原环境。[LispWorks 进程参考](https://www.lispworks.com/documentation/lw81/lw/lw-sys-115.htm)

在 LispWorks 和 ECL 上，`(run-program "./worker" :directory dir ...)` 会选取 `dir` 中的可执行文件。子进程收到的程序名仍为 `"./worker"`。操作系统的实际工作目录与环境变量 `PWD`、`OLDPWD` 相互独立，子进程进入 `dir` 后仍可收到调用方为这两个变量指定的值。SBCL 在启动前会先从父目录检查相对程序路径。需要同一种调用形式兼容三个实现时，传入可执行文件的绝对路径。在 Linux 上，LispWorks 8.1.2 需要能读取、进入所指定的子目录，并能访问 `/proc/self/fd`。模式为 `0111`（仅有执行权限）的目录在 Linux 实测触发权限错误，在 macOS 实测可进入并启动子进程。处理执行失败时，要检查启动是否成功，也要检查子进程的[退出状态](process-exit-code.zh-CN.md)。如果脚本有执行权限但解释器缺失，ECL 会在启动时触发错误。LispWorks 在这种情况下可能先返回句柄，调用方等待后会得到失败状态。

ECL 在显式传入 `:directory` 时，要求系统 C 库支持在 `posix_spawn` 期间切换子进程工作目录。如果 C 库缺少这项操作，此调用会触发启动错误。

## 示例

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

在调用方选定的目录运行工具，同时保留父进程的工作目录。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let ((child (han.host:run-program "/bin/pwd" :directory root)))
         (unwind-protect
              (progn (han.host:process-wait child)
                     (let ((reported (read-line (han.host:host-process-output-stream child))))
                       (string= (namestring (truename root))
                                (namestring (truename (uiop:ensure-directory-pathname reported))))))
           (han.host:process-close child)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => T
```

在文件系统根目录中启动子进程，读取调用方显式提供的 `PWD` 值。

```lisp
(let* ((environment #+lispworks '(("PWD" . "caller-value"))
                    #-lispworks '("PWD=caller-value"))
       (child (han.host:run-program "/usr/bin/printenv"
                                    :arguments '("PWD")
                                    :directory #P"/"
                                    :environment environment)))
  (unwind-protect
       (let ((line (read-line (han.host:host-process-output-stream child) nil)))
         (han.host:process-wait child)
         (list line (han.host:process-exit-code child)))
    (han.host:process-close child)))
;; => ("caller-value" 0)
```

程序路径缺失时，启动阶段即触发错误，不会返回可用句柄。

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:run-program (namestring (han.path:join-path file "no-program"))))
;; signals simple-error
```

[`han.host:run-program-sync`](run-program-sync.zh-CN.md) · [`han.host:process-wait`](process-wait.zh-CN.md) · [`han.host:process-close`](process-close.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [索引](../README.zh-CN.md)
