# `han.os:require-env`

*Function · 函数*

## Syntax · 语法

```text
(han.os:require-env name) → environment string
```

## Description · 说明

Returns the value of the named environment variable, including an explicitly empty string. Signals an error if the variable is unset. The example handles either environment while checking the matching behavior.

返回指定环境变量的字符串值，包括显式设置的空字符串。变量缺失时触发错误。示例根据实际环境验证有值和缺失两种情形。

## Examples · 示例

Check the value when the variable is set and catch the error when it is missing.

变量已设置时核对它的值，未设置时捕获错误。

```lisp
(let* ((name "HAN_MANUAL_REQUIRED_VALUE")
       (value (han.host:getenv name)))
  (if value
      (string= value (han.os:require-env name))
      (handler-case (progn (han.os:require-env name) nil)
        (error () t))))
;; => T
```

Reject an unconfigured batch job at startup. The child converts a missing environment variable into a recognizable exit status.

批处理任务启动时检查配置。子进程将缺失的环境变量映射为约定的退出状态。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_DATASET" "sbcl" "--noinform" "--no-sysinit" "--no-userinit" "--disable-debugger"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(handler-case (progn (han.os:require-env \"HAN_DOCS_DATASET\") (han.host:quit 0)) (error () (han.host:quit 64)))" "--quit")))
;; => 64
```

[`han.os:getenv-default`](getenv-default.md) · [`han.host:getenv`](../host/getenv.md) · [env.lisp](../../../os/env.lisp) · [Index · 索引](../README.md)
