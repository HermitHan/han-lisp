# `han.host:run-program`

[简体中文](run-program.zh-CN.md)

*Function*

## Syntax

```text
(han.host:run-program program &key (arguments '()) input directory environment) → host-process
```

## Description

Starts an external program asynchronously. Supply an existing executable file path and its argument strings. Supply `directory` to start the child in an existing working directory. The parent keeps its current directory. Spaces and shell metacharacters in arguments remain literal. The result owns separate stdout and stderr pipes. The caller drains them, waits for termination, and closes the handle. A missing program signals an error.

On CCL, `:input :stream` gives the caller a live pipe. A supplied file or string input stream contributes its unread contents. For a terminal or pipe already open on an OS descriptor, the child reads the descriptor directly.

Omitting `environment` inherits the parent environment. On SBCL, ECL and CCL an explicit list such as `'("MODE=fast")` replaces it, and `:environment nil` starts with an empty environment. On LispWorks, an alist such as `'(("MODE" . "fast"))` augments the inherited environment. An explicit `nil` therefore inherits it unchanged. [LispWorks process reference](https://www.lispworks.com/documentation/lw81/lw/lw-sys-115.htm)

On LispWorks, ECL and CCL, `(run-program "./worker" :directory dir ...)` selects the executable in `dir`. The child receives `"./worker"` as its program name. The operating system’s working directory and the environment variables `PWD` and `OLDPWD` are independent. The child can run in `dir` and still receive values explicitly provided for those variables. SBCL checks that a relative program exists in the parent directory before launch. Use an absolute executable path when the same invocation must work on all four implementations. On Linux, LispWorks 8.1.2 needs a readable, searchable child directory and access to `/proc/self/fd`. A directory with mode `0111` produced a permission error on Linux and allowed the child to start on macOS. If execution fails, check both the launch and the child’s [exit status](process-exit-code.md). ECL and CCL signal a launch error for an executable script with a missing interpreter. LispWorks may return a process handle for that case and report failure when the caller waits.

On ECL and CCL, supplying `:directory` requires the system C library to support changing the child’s directory during `posix_spawn`. If that operation is unavailable, the call signals a launch error.

## Examples

Start a shell, wait for it to finish, then read its output and exit code.

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

Start in the filesystem root and read the caller’s explicit `PWD` value from the child.

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

Passing a missing executable path fails at launch, before a process handle is returned.

```lisp
(uiop:with-temporary-file (:pathname file)
  (han.host:run-program (namestring (han.path:join-path file "no-program"))))
;; signals simple-error
```

[`han.host:run-program-sync`](run-program-sync.md) · [`han.host:process-wait`](process-wait.md) · [`han.host:process-close`](process-close.md) · [sbcl.lisp](../../../host/sbcl.lisp) · [lispworks.lisp](../../../host/lispworks.lisp) · [ecl.lisp](../../../host/ecl.lisp) · [ccl.lisp](../../../host/ccl.lisp) · [Index](../README.md)
