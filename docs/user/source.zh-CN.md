# `han.source`

[用户手册](README.zh-CN.md) · [English](source.md) · [本包符号参考](../reference/README.md#source)

使用 `han.source` 可以为字符串写小型词法分析器或解析器。一个字符源有自己的可移动游标；标记保存某一刻的位置，区间保存同一字符源内的一段文本范围。语法、产生的 token 和出错后的处理由调用方定义。

## 读取键值并保存字段范围

下面从 `port=80` 读取字段和值，再读过换行符，记录下一行的起始位置。最后回到第一行，从已保存的区间取出字段原文。

```lisp
(let* ((src (han.source:make-char-source (format nil "port=80~%next")))
       (start (han.source:make-source-mark src))
       (name (han.source:source-read-while src #'alpha-char-p))
       (span (han.source:make-source-span start (han.source:make-source-mark src))))
  (assert (han.source:source-consume-char-if src #\=))
  (let ((value (parse-integer (han.source:source-read-while src #'digit-char-p))))
    (han.source:source-next-char src)
    (let ((next-line (multiple-value-list (han.source:source-location src))))
      (han.source:source-reset src start)
      (list name value next-line
            (han.source:source-slice-by-span src span)
            (han.source:source-peek-string src 4)))))
;; => ("port" 80 (8 2 1) "port" "port")
```

`(8 2 1)` 表示已消耗八个字符，游标位于第二行第一列。索引从 0 开始，行列从 1 开始，单位是 Lisp 字符。读过 `#\Newline` 后行号加一，列号重置为 1。只有移动游标才会改变这些坐标，取子串和查看后续文本都保持当前位置。

## 尝试一个分隔符

先试较长的 `::`；失配后仍可从原处尝试单字符 `:`。这种条件消耗适合有共同前缀的标点。

```lisp
(let ((src (han.source:make-char-source ":x")))
  (list (han.source:source-consume-string-if src "::")
        (han.source:source-peek-string src 3)
        (han.source:source-consume-char-if src #\:)
        (han.source:source-read-while src #'alpha-char-p)
        (han.source:source-eof-p src)))
;; => (NIL ":x" #\: "x" T)
```

空串与任何位置匹配。若在循环中用 `source-consume-string-if` 推进输入，匹配串应至少含一个字符。每次 `make-char-source` 都产生独立的来源，即使输入文本完全相同也如此；只有同源的标记才能用于回退。

## 导出接口

导出的三个结构类型是 `char-source`、`char-source-mark`、`char-source-span`。以下函数均可用 `han.source:` 前缀调用。

### 创建游标、读取位置

| 函数 | 参数 | 行为与返回值 |
| --- | --- | --- |
| [`make-char-source`](../reference/source/make-char-source.md) | `(string)` | 复制输入字符串，返回位置为 `(0, 1, 1)` 的新 [`char-source`](../reference/source/char-source.md)。 |
| [`char-source-p`](../reference/source/char-source-p.md) | `(object)` | 判断对象是否为字符源。 |
| [`char-source-string`](../reference/source/char-source-string.md) | `(src)` | 返回字符源持有的字符串。请按只读方式使用，以便标记和坐标始终指向同一份文本。 |
| [`char-source-length`](../reference/source/char-source-length.md) | `(src)` | 返回文本的字符数。 |
| [`source-location`](../reference/source/source-location.md) | `(source-or-mark)` | 返回三个值，依次为字符索引、行号和列号。参数可以是字符源或已保存的标记。 |
| [`source-eof-p`](../reference/source/source-eof-p.md) | `(src)` | 游标已到末尾时为真。 |

### 前瞻与消耗字符

| 函数 | 参数 | 行为与返回值 |
| --- | --- | --- |
| [`source-peek-char`](../reference/source/source-peek-char.md) | `(src)` | 读当前位置的字符，末尾返回 `nil`。游标保持原位。 |
| [`source-peek-string`](../reference/source/source-peek-string.md) | `(src n)` | 从游标处向后查看至多 `n` 个字符。`n` 取非负数，末尾返回 `""`。 |
| [`source-match-char-p`](../reference/source/source-match-char-p.md) | `(src ch)` | 判断当前位置的字符是否匹配，区分大小写。 |
| [`source-match-string-p`](../reference/source/source-match-string-p.md) | `(src target)` | 判断以当前位置开头的文本是否与 `target` 完全匹配，游标保持原位。空串在末尾也匹配。 |
| [`source-next-char`](../reference/source/source-next-char.md) | `(src)` | 返回当前位置的字符并前进一步。末尾返回 `nil`。 |
| [`source-consume-char-if`](../reference/source/source-consume-char-if.md) | `(src ch)` | 匹配时前进一步并返回 `ch`，失配时返回 `nil` 并停在原位。 |
| [`source-consume-string-if`](../reference/source/source-consume-string-if.md) | `(src str)` | 匹配时前进 `str` 的长度并返回该字符串，失配时返回 `nil` 并停在原位。 |
| [`source-advance-n`](../reference/source/source-advance-n.md) | `(src n)` | 向前移动至多 `n` 个字符，到达末尾即停，返回 `src`。 |
| [`source-skip-while`](../reference/source/source-skip-while.md) | `(src predicate)` | 依次把当前位置的字符传给 `predicate`，在返回真期间持续前进，最后返回 `src`。 |
| [`source-read-while`](../reference/source/source-read-while.md) | `(src predicate)` | 消耗连续满足 `predicate` 的字符并以字符串返回。首字符失配或已达末尾时返回 `""`。 |

### 保存标记、提取区间

| 函数 | 参数 | 行为与返回值 |
| --- | --- | --- |
| [`make-source-mark`](../reference/source/make-source-mark.md) | `(src)` | 把来源和当前位置保存为 [`char-source-mark`](../reference/source/char-source-mark.md)。游标继续前进后，标记仍指向原位置。 |
| [`char-source-mark-p`](../reference/source/char-source-mark-p.md) | `(object)` | 判断对象是否为标记。 |
| [`source-reset`](../reference/source/source-reset.md) | `(src mark)` | 用该字符源的标记恢复索引、行号和列号，返回 `src`。 |
| [`make-source-span`](../reference/source/make-source-span.md) | `(start end)` | 以同一字符源的两个标记创建 [`char-source-span`](../reference/source/char-source-span.md)。两者同位时得到空区间，终点早于起点时报错。 |
| [`char-source-span-p`](../reference/source/char-source-span-p.md) | `(object)` | 判断对象是否为区间。 |
| [`source-slice`](../reference/source/source-slice.md) | `(src start &optional end)` | 复制从 `start` 到 `end` 的左闭右开子串。`end` 默认是当前游标；两端均可使用合法非负索引或来自 `src` 的标记。 |
| [`source-slice-by-span`](../reference/source/source-slice-by-span.md) | `(src span)` | 取出 `span` 覆盖的子串。区间来自其他字符源时会报错。 |
| [`source-mark-from-source-p`](../reference/source/source-mark-from-source-p.md) | `(mark src &optional report-error)` | 检查标记是否属于 `src`。`report-error` 为真时，来源不符会报错。 |
| [`source-span-from-source-p`](../reference/source/source-span-from-source-p.md) | `(span src &optional report-error)` | 检查区间是否属于 `src`。`report-error` 为真时，来源不符会报错。 |
| [`source-same-origin-p`](../reference/source/source-same-origin-p.md) | `(target &rest others)` | 混合传入字符源、标记和区间；全部同源时返回真。 |

### 包信息

| 函数 | 参数 | 行为与返回值 |
| --- | --- | --- |
| [`help`](../reference/source/help.md) | `(&optional stream)` | 返回帮助字符串，默认写到 `*standard-output*`。传入 `nil` 时只返回字符串。 |
| [`version`](../reference/source/version.md) | `(&optional stream)` | 返回版本字符串，默认打印包名和版本。传入 `nil` 时只返回版本字符串。 |

[导出声明](../../source/package.lisp) · [游标与区间实现](../../source/char-source.lisp) · [回归用例](../../source/test.lisp)
