# `han.host:process-status`

[English](process-status.md)

*函数*

## 语法

```text
(han.host:process-status process) → status keyword
```

## 说明

非阻塞查询实际进程句柄。SBCL、ECL 和 CCL 将原生状态映射为 `:running`、`:exited` 或 `:unknown`（如暂停状态）。暂停的子进程恢复执行后，CCL 1.14 仍可能返回 `:unknown`，直到它观察到进程终止。LispWorks 在取得退出码之前报告 `:running`，之后返回 `:exited`。示例先等待结束以取得确定结果。

## 示例

等待子进程退出后再查询状态。

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (han.host:process-status child))
    (han.host:process-close child)))
;; => :EXITED
```

子进程等待私有文件信号时查询运行状态，再放行并取得结束状态。

```lisp
(let ((root (uiop:ensure-directory-pathname (uiop:run-program '("mktemp" "-d") :output :line))))
  (unwind-protect
       (let* ((gate (merge-pathnames "release" root))
              (script "i=0; while [ ! -f \"$1\" ] && [ \"$i\" -lt 200 ]; do i=$((i+1)); sleep .05; done")
              (worker (han.host:run-program "/bin/sh"
                        :arguments (list "-c" script "waiter" (namestring gate)))))
         (unwind-protect
              (let ((before (han.host:process-status worker)))
                (han.host:append-utf8-line gate "")
                (han.host:process-wait worker)
                (list before (han.host:process-status worker)))
           (han.host:process-close worker)))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore)))
;; => (:RUNNING :EXITED)
```

[`han.host:process-wait`](process-wait.zh-CN.md) · [`han.host:process-exit-code`](process-exit-code.zh-CN.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [索引](../README.zh-CN.md)
