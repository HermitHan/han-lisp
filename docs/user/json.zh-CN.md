# han.json · 读写 JSON

[用户手册](README.zh-CN.md) · [English](json.md) · [本包符号参考](../reference/README.md#json)

`han.json` 可以读取配置文档，用普通 Lisp 数据结构查询、修改内容，再写回 JSON。解析出的对象是采用 `equal` 比较的哈希表，字符串键区分大小写。数组是向量，因此可以将对象查询与 Common Lisp 的序列操作组合使用。

## 读取嵌套记录

假设配置里有一组任务。第一个任务显式关闭重试，把超时设为 `null`，并且省略了优先级。读取优先级时，希望缺省取 3。

```lisp
(let* ((config (han.json:parse-json
                "{\"jobs\":[{\"retry\":false,\"timeout\":null}]}"))
       (job (aref (han.json:get-json config "jobs") 0)))
  (list (multiple-value-list (han.json:get-json job "retry"))
        (multiple-value-list (han.json:get-json job "timeout"))
        (multiple-value-list (han.json:get-json job "priority" 3))))
;; => ((NIL T) (:NULL T) (3 NIL))
```

`get-json` 每次查询一层对象，返回字段值和表示键是否存在的第二个值。即使字段值为 `nil`，存在标志仍为真。缺少键时，返回调用方给的默认值（缺省为 `nil`）和假。对非对象查询也返回默认值和假。读取结构未知的数据时，可以先用 `json-object-p`、`json-array-p` 检查容器类型，再检查向量长度后取元素。

| JSON 输入 | 对应的 Lisp 值 |
| --- | --- |
| 对象，包括 `{}` | 采用 `equal` 比较的哈希表。重复键取最后一次出现的值。 |
| 数组，包括 `[]` | 向量，`[]` 对应空向量。使用 `aref` 或 `elt`，索引从 0 开始。 |
| 字符串 | Lisp 字符串。解析时会处理转义，包括成对的 Unicode 代理项转义。 |
| 数值 | 整数字面量解析为 Lisp 整数，带小数点或指数的数解析为双精度浮点数。 |
| `true`、`false`、`null` | 分别对应 `t`、`nil`、`:null`。 |

## 构建并输出文档

每个字段用一个 cons 表示，`car` 是字符串键，`cdr` 就是字段的完整值。不给构造器传键值对即可创建空对象。用 `(han.json:json-array)` 创建空数组。Lisp 空列表的值为 `nil`，编码结果为 `false`。

```lisp
(let ((job (han.json:json-object
            (cons "stages" (han.json:json-array "read" "index"))
            (cons "retry" nil))))
  (han.json:set-json job "timeout" :null)
  (han.json:encode-json job :indent nil))
;; => "{\"retry\":false,\"stages\":[\"read\",\"index\"],\"timeout\":null}"
```

编码时，对象字段按宿主 Lisp 的 `string<` 顺序输出；这不保证不同实现产生逐字节完全相同的文本。默认参数 `:indent 2` 使每层缩进两个空格，并在文末换行。指定 `:indent nil` 可得到结尾没有换行的紧凑字符串。数值可用整数或浮点数。已有非空列表可用 `(coerce items 'vector)` 转为数组。编码器也接受 `:false` 来表示 JSON 的 `false`。

## 字符与数值的边界

`\u6C49` 这样的转义解析为一个 Lisp 字符；`\uD83D\uDE00` 这样的代理对也解析为一个字符（U+1F600）。单独的代理码或宿主无法映射的标量会触发 [`json-error`](../reference/json/json-error.md)。写字符串时，可打印 ASCII 范围之外的字符会被转义，因此直接输入字符和输入等价的 Unicode 转义，重新编码后结果相同。文件接口指定 UTF-8；传给 `write-json` 的字符流沿用打开时的编码。

整数字面量可以精确表示。带小数点或指数的数会转为宿主的 `double-float`，可能发生舍入；指数过大或过小还可能触发算术条件。例如，价格必须精确时，可以用整数记录分。写出时，整数始终使用十进制，有限浮点数的具体写法可以因 Lisp 实现而异。调用方无需绑定 Lisp 的打印变量。

## 公开接口

下列名称均由 `han.json` 导出。

| 读取与构造 | 行为 |
| --- | --- |
| [`(parse-json string)`](../reference/json/parse-json.md) | 解析一个完整 JSON 值，允许末尾空白。语法错误、尾逗号或尾随的第二个值会触发 [`json-error`](../reference/json/json-error.md)。 |
| [`(parse-json-file path)`](../reference/json/parse-json-file.md)、[`(read-json-file path)`](../reference/json/read-json-file.md) | 按 UTF-8 将文件完整读入并解析，二者都返回解码值。文件系统错误按原有条件类型传出。 |
| [`(make-json-object &optional pairs)`](../reference/json/make-json-object.md) | 接受由字符串键 cons 对组成的列表，例如 `'(("count" . 2))`，返回新对象。 |
| [`(json-object &rest pairs)`](../reference/json/json-object.md)、[`(json-array &rest values)`](../reference/json/json-array.md) | 将逐个传入的键值对构造成新对象，或将逐个传入的值组成向量。 |
| [`(json-object-p value)`](../reference/json/json-object-p.md)、[`(json-array-p value)`](../reference/json/json-array-p.md)、[`(json-null-p value)`](../reference/json/json-null-p.md) | 分别判断哈希表、非字符串向量和 `:null`。前两者只检查容器类型，元素内容需另外验证。 |
| [`(json-keys object)`](../reference/json/json-keys.md) | 返回按 `string<` 排序的字符串键列表。 |
| [`(get-json object key &optional default)`](../reference/json/get-json.md) | 按字符串键查询，返回字段值和存在标志。 |
| [`(set-json object key value)`](../reference/json/set-json.md) | 原地更新哈希表，返回刚存入的值。 |

| 输出与诊断 | 行为 |
| --- | --- |
| [`(encode-json value &key (indent 2))`](../reference/json/encode-json.md) | 返回 JSON 文本字符串。 |
| [`(write-json value stream &key (indent 2))`](../reference/json/write-json.md) | 写入字符输出流，返回传入的值。 |
| [`(write-json-file path value &key (indent 2))`](../reference/json/write-json-file.md) | 创建缺少的父目录，并以 UTF-8 写文件。目标存在时会覆盖。返回传入的路径。 |
| `json-error` | JSON 语法错误或值无法表示时使用的条件类型。可通过 `handler-case` 捕获并向调用方报告。 |
| [`(help &optional stream)`](../reference/json/help.md)、[`(version &optional stream)`](../reference/json/version.md) | 返回帮助文本或包版本字符串，默认也打印到标准输出。传入 `nil` 可以只取返回值。 |

[导出声明](../../json/package.lisp) · [实现](../../json/core.lisp) · [回归测试](../../json/test.lisp)
