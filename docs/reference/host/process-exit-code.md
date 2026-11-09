# `han.host:process-exit-code`

[简体中文](process-exit-code.zh-CN.md)

*Function*

## Syntax

```text
(han.host:process-exit-code process) → integer or nil
```

## Description

Returns the exit status when it is available, otherwise `nil`. Inspect it after `process-wait` for a completed child. All three adapters preserve ordinary exit codes, including zero. On Unix, when a signal terminates the child, SBCL returns the signal number and LispWorks and ECL return 128 plus that number. For example, SIGTERM gives 15 on SBCL and 143 on LispWorks and ECL. An ordinary exit can use the same integer.

## Examples

Wait for a child that exits with code 4, then read the code from its handle.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 4"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (han.host:process-exit-code child))
    (han.host:process-close child)))
;; => 4
```

Translate a worker's exit status into a caller-defined decision.

```lisp
(let ((child (han.host:run-program "/bin/sh" :arguments '("-c" "exit 2"))))
  (unwind-protect
       (progn
         (han.host:process-wait child)
         (case (han.host:process-exit-code child)
           (0 :ok)
           (2 :bad-input)
           (otherwise :failed)))
    (han.host:process-close child)))
;; => :BAD-INPUT
```

[`han.host:process-wait`](process-wait.md) · [`han.host:run-program-sync`](run-program-sync.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [Index](../README.md)
