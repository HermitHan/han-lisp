# `han.test:help`

[English](help.md)

*函数*

## 语法

```text
(han.test:help &optional (stream *standard-output*)) → text
```

## 说明

返回包内置帮助字符串，包含用例注册、运行器和断言用法。默认同时打印到标准输出。传入 `nil` 可静默取得文本，也可指定字符输出流接收帮助内容。

## 示例

静默获取帮助文本，并检查其中是否有需要的接口名。

```lisp
(let ((text (han.test:help nil)))
  (and (stringp text) (not (null (search "run-all-tests" text)))))
;; => T
```

将帮助发往调用方的流，并核对流中收到的文本与函数返回值。

```lisp
(let ((out (make-string-output-stream)))
  (let ((text (han.test:help out)))
    (string= text (get-output-stream-string out))))
;; => T
```

[`version`](version.zh-CN.md) · [源码](../../../test/package.lisp#L47) · [索引](../README.zh-CN.md)
