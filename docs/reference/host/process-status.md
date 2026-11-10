# `han.host:process-status`

[简体中文](process-status.zh-CN.md)

*Function*

## Syntax

```text
(han.host:process-status process) → status keyword
```

## Description

Queries a live handle without waiting. SBCL, ECL and CCL map the native state to `:running`, `:exited` or `:unknown` (for example, a stopped process). CCL 1.14 can continue to report `:unknown` after a stopped child resumes, until it observes termination. LispWorks reports `:running` until an exit code is available, then `:exited`. Waiting first makes this example deterministic.

## Examples

Query the status of a child after waiting for it to exit.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 0"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (han.host:process-status child))
    (han.host:process-close child)))
;; => :EXITED
```

Inspect a running worker before releasing its file gate and waiting for exit.

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

[`han.host:process-wait`](process-wait.md) · [`han.host:process-exit-code`](process-exit-code.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [Index](../README.md)
