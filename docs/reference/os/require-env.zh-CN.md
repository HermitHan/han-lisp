# `han.os:require-env`

[English](require-env.md)

*函数*

## 语法

```text
(han.os:require-env name) → environment string
```

## 说明

返回指定环境变量的字符串值，包括显式设置的空字符串。变量缺失时触发错误。示例根据实际环境验证有值和缺失两种情形。

## 示例

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

批处理任务启动时检查配置。子进程将缺失的环境变量映射为约定的退出状态。

```lisp
(nth-value 2
  (han.host:run-program-sync
   (list "/usr/bin/env" "-u" "HAN_DOCS_DATASET" #+ecl (first (han.host:argv t)) #-ecl (han.host:find-executable "sbcl")
         #+ecl "--norc" #-ecl "--no-userinit"
         #+ecl "--nodebug" #-ecl "--non-interactive"
         "--load" (namestring (asdf:system-relative-pathname "han" "load-han.lisp"))
         "--eval" "(handler-case (progn (han.os:require-env \"HAN_DOCS_DATASET\") (han.host:quit 0)) (error () (han.host:quit 64)))" "--eval" "(han.host:quit)")))
;; => 64
```

[`han.os:getenv-default`](getenv-default.zh-CN.md) · [`han.host:getenv`](../host/getenv.zh-CN.md) · [env.lisp](../../../os/env.lisp) · [索引](../README.zh-CN.md)
