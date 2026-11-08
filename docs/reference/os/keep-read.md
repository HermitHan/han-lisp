# `han.os:keep-read`

*Function · 函数*

## Syntax · 语法

```text
(han.os:keep-read &optional (stream *standard-input*) (limit nil)) → list of Lisp objects
```

## Description · 说明

Calls `read` repeatedly, returning Lisp objects in input order. EOF ends the read. An integer limit can bound the result count. A function limit is called before every read with the already-read list in reverse order. Reading stops when it returns false. Standard Lisp reader syntax and the caller's reader settings apply. Reader errors propagate.

反复调用 `read`，按输入顺序返回 Lisp 对象列表。遇到 EOF 时停止。整数限制读取项数，也可传函数作为 limit，在每次读取前以已读列表的逆序调用它，返回假则停止。遵循 Lisp 读取器语法及调用者的读取设置，读取错误会传播。

## Examples · 示例

Read two Lisp objects, then collect the remaining objects from the same stream.

先读取两个 Lisp 对象，再从同一条流读出剩余对象。

```lisp
(with-input-from-string (input "10 (20 30) 40")
  (let ((*read-eval* nil))
    (list (han.os:keep-read input 2) (han.os:keep-read input))))
;; => ((10 (20 30)) (40))
```

Stop after a Lisp sentinel and continue parsing the remaining forms separately.

遇到 Lisp 标记后停止，剩余表达式可随后单独读取。

```lisp
(with-input-from-string (in "10 :end (:next 20)")
  (let ((*read-eval* nil))
    (list (han.os:keep-read in (lambda (rev) (not (eq (first rev) :end))))
          (read in))))
;; => ((10 :END) (:NEXT 20))
```

[`han.os:keep-read-line`](keep-read-line.md) · [`han.os:keep-read-char`](keep-read-char.md) · [io.lisp](../../../os/io.lisp) · [Index · 索引](../README.md)
