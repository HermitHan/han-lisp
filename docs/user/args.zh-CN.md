# `han.args`

[用户手册](README.zh-CN.md) · [English](args.md) · [本包符号参考](../reference/README.md#args)

当一个 Lisp 命令需要选项、位置参数或分段传递参数时，用 `han.args` 描述它接受的输入。你可以在程序启动时建立一次规格，再用不同的字符串列表做绑定和测试。调用方决定遇到错误是否退出，以及怎样把诊断呈现给用户。

## 解析一个命令

`inspect` 接受样本名、输入文件和可选开关。`@filter:` 开启一个命名块，里面的 `--mode` 属于该块。输入是命令名开头的字符串列表，已经由调用方或 shell 划分好各项。

```lisp
(let* ((specs (han.args:parse-args-spec
               (mapcar #'han.args:parse-arg-spec
                       '("!(--/-i)input" "(--/-v)verbose?"
                         "report=@{input}.json" "(@:)filter" "$1"))
               "inspect"))
       (input (han.args:parse-args-input
               '("inspect" "sample" "-i" "notes.txt" "-v"
                 "@filter:" "--mode" "exact")))
       (result (han.args:bind-args specs input)))
  (list (multiple-value-list (han.args:get-arg "input" result))
        (multiple-value-list (han.args:get-arg "report" result))
        (han.args:get-arg 1 result)
        (han.args:get-arg "verbose" result)
        (mapcar #'han.args:arg-token-text (han.args:get-arg "filter" result))
        (han.args:args-result-diagnostics result)))
;; => (("notes.txt" :INPUT) ("notes.txt.json" :DEFAULT) "sample" T ("--mode" "exact") NIL)
```

可以从 `get-arg` 的第二返回值区分用户输入和默认值。块返回保留原始文本的 token，示例用 `arg-token-text` 取得字符串，便于把参数继续传递给其他程序。

## 规格写法

| 规格 | 含义 |
| --- | --- |
| `!(--/-i)input` | 必需的单值选项，可写 `--input` 或 `-i`。`--input=` 和单独传入的空字符串都表示已提供空值。 |
| `(--/-t)threads=4` | 省略时得到字符串 `"4"`。需要数值时由调用方转换。 |
| `(--/-v)verbose?` | 开关。按此规格，出现时返回 `t`／`:input`，省略时返回 `nil`／`:missing`。 |
| `(@:)filter` | 把 `@filter:` 之后的 token 收为列表，遇到下一次切换槽时结束。`@:` 切回顶层选项。 |
| `$1`, `$2` | 顶层的必需位置参数，编号从 `$0` 或 `$1` 开始并连续。以 `$0` 起算时，它取第一个位置参数。命令名由 [`args-input-raw-cmd`](../reference/args/args-input-raw-cmd.md) 返回。 |
| `report=@{input}.json` | 查询时按引用和字面文本组合字符串。单独的 `@name` 会传递目标值及状态，拼接字符串的状态为 `:default`。循环引用在查询时报错。 |
| `%mode=brief` | 将可见性设为 `:hidden`。应用生成帮助时可以据此决定是否展示。 |

长、短选项在括号内用 `/` 分开。`--` 和 `-` 的简写入口会分别按全名和名称的首字符展开。在 argv 中，独立的 `--` 被当作带警告的普通值；以 `-` 开头的数值可用 `--limit=-2` 传给单值选项。

## 检查诊断

```lisp
(let* ((specs (han.args:parse-args-spec
               (list (han.args:parse-arg-spec "!(--/-i)input"))))
       (input (han.args:parse-args-input '("inspect")))
       (result (han.args:bind-args specs input)))
  (list (multiple-value-list (han.args:get-arg "input" result))
        (mapcar #'han.args:arg-diagnostic-code
                (han.args:args-result-diagnostics result))))
;; => ((NIL :MISSING) (:MISSING-REQUIRED))
```

已声明的参数可能返回 `:input`、`:default`、`:missing` 或 `:conflict`。查询不存在的名称返回两个 `nil`。必需值缺失、单值选项缺少值、重复提供同一单值选项或块会产生 `:error`。未定义的选项或槽、未使用的位置参数会产生 `:warning`。可按 `arg-diagnostic-kind` 筛选诊断；词法警告的 `arg-diagnostic-code` 可以是 `nil`。

## 函数

以下名称均由 `han.args` 导出，调用时使用 `han.args:` 前缀。

| 函数 | 参数 | 行为与返回值 |
| --- | --- | --- |
| [`parse-args-input`](../reference/args/parse-args-input.md) | `(&optional raw-input-args add-cmd)` | 将 `add-cmd` 列表放到输入字符串列表之前，取首项为命令，其余为参数。省略输入时读取 `(han.host:argv t)`。返回 [`args-input`](../reference/args/args-input.md)。 |
| [`parse-arg-spec`](../reference/args/parse-arg-spec.md) | `(spec-string)` | 解析并校验一条规格字符串，返回 [`arg-spec`](../reference/args/arg-spec.md)。 |
| [`parse-args-spec`](../reference/args/parse-args-spec.md) | `(spec-list &optional command)` | 把 `arg-spec` 对象列表合并为 [`args-spec`](../reference/args/args-spec.md)。命令名默认是 `"my-args"`。同名声明中相容的字段会合并。字段冲突或不同参数使用相同入口时会报错。 |
| [`bind-args`](../reference/args/bind-args.md) | `(args-spec args-input &optional builtin-table)` | 绑定值并把诊断收集到 [`args-result`](../reference/args/args-result.md)。如需注入内置值，`builtin-table` 应是从名称映射到带状态的 [`arg-binding`](../reference/args/arg-binding.md) 对象的哈希表。省略该参数时会创建空表。用 `equalp` 建表可按字符串名称忽略大小写查询。 |
| [`get-arg`](../reference/args/get-arg.md) | `(name-or-spec args-result &optional history)` | 接受规格字符串、`arg-spec` 或位置整数，返回值与状态。查询优先匹配内置绑定。`history` 用于递归查询时记录引用路径，应用程序调用时可省略。 |
| [`arg-key-equal`](../reference/args/arg-key-equal.md) | `(x y)` | 两个字符串按 `string-equal` 比较，其他键按 `eql` 比较。 |
| [`help`](../reference/args/help.md) | `(&optional stream)` | 返回帮助字符串，默认写到 `*standard-output*`。传入 `nil` 时只返回字符串。 |
| [`version`](../reference/args/version.md) | `(&optional stream)` | 返回版本字符串，默认打印包名和版本。传入 `nil` 时只返回版本字符串。 |

## 检查解析记录

通常通过解析和绑定函数取得这些结构对象。每种类型的谓词接收一个对象；字段访问器接收相应类型的实例。若需自行构造，可向构造器传字段对应的关键字参数，例如 `make-arg-binding` 接受 `:name`、`:spec`、`:value`、`:status`。

| 类型／谓词／构造器 | 访问器（按说明顺序排列） | 字段含义 |
| --- | --- | --- |
| [`arg-token`](../reference/args/arg-token.md), [`arg-token-p`](../reference/args/arg-token-p.md), [`make-arg-token`](../reference/args/make-arg-token.md) | [`arg-token-kind`](../reference/args/arg-token-kind.md), [`arg-token-text`](../reference/args/arg-token-text.md), [`arg-token-value`](../reference/args/arg-token-value.md), [`arg-token-extra`](../reference/args/arg-token-extra.md), [`arg-token-position`](../reference/args/arg-token-position.md) | 分类（`:long-option`、`:short-option`、`:slot-switch`、`:value`）、原文、规范化名称或值、选项首个 `=` 之后的文本（没有时为 `nil`）、去掉命令名后在 argv 中从零开始的位置。 |
| [`arg-segment`](../reference/args/arg-segment.md), [`arg-segment-p`](../reference/args/arg-segment-p.md), [`make-arg-segment`](../reference/args/make-arg-segment.md) | [`arg-segment-slot`](../reference/args/arg-segment-slot.md), [`arg-segment-positions`](../reference/args/arg-segment-positions.md) | 槽名（顶层为 `nil`）与成员在 token 向量中的索引列表。切换槽的标记本身不计入。 |
| `args-input`, [`args-input-p`](../reference/args/args-input-p.md), [`make-args-input`](../reference/args/make-args-input.md) | `args-input-raw-cmd`, [`args-input-raw-argv`](../reference/args/args-input-raw-argv.md), [`args-input-tokens`](../reference/args/args-input-tokens.md), [`args-input-segments`](../reference/args/args-input-segments.md), [`args-input-diagnostics`](../reference/args/args-input-diagnostics.md) | 命令名、命令之后的原始参数字符串列表、token 向量、按输入顺序排列的段列表、词法诊断列表。 |
| [`arg-diagnostic`](../reference/args/arg-diagnostic.md), [`arg-diagnostic-p`](../reference/args/arg-diagnostic-p.md), [`make-arg-diagnostic`](../reference/args/make-arg-diagnostic.md) | [`arg-diagnostic-kind`](../reference/args/arg-diagnostic-kind.md), [`arg-diagnostic-code`](../reference/args/arg-diagnostic-code.md), [`arg-diagnostic-message`](../reference/args/arg-diagnostic-message.md), [`arg-diagnostic-position`](../reference/args/arg-diagnostic-position.md) | 严重程度（`:error` 或 `:warning`）、可选的诊断码、说明文字、可定位时的 argv 索引。 |
| `arg-spec`, [`arg-spec-p`](../reference/args/arg-spec-p.md), [`make-arg-spec`](../reference/args/make-arg-spec.md) | [`arg-spec-name`](../reference/args/arg-spec-name.md), [`arg-spec-long-entry`](../reference/args/arg-spec-long-entry.md), [`arg-spec-short-entry`](../reference/args/arg-spec-short-entry.md), [`arg-spec-slot-entry`](../reference/args/arg-spec-slot-entry.md), [`arg-spec-arity`](../reference/args/arg-spec-arity.md), [`arg-spec-required`](../reference/args/arg-spec-required.md), [`arg-spec-visibility`](../reference/args/arg-spec-visibility.md), [`arg-spec-default`](../reference/args/arg-spec-default.md) | 查询名（字符串或位置整数）、带前后标记的长选项／短选项／槽入口、参数形态（`:single`、`:flag`、`:block`、`:position`）、是否必需、可见性（`:public` 或 `:hidden`）、解析后的默认值。默认值可以是字符串、`nil`、`:query` 或 `:concat` 表达式。 |
| `args-spec`, [`args-spec-p`](../reference/args/args-spec-p.md), [`make-args-spec`](../reference/args/make-args-spec.md) | [`args-spec-command`](../reference/args/args-spec-command.md), [`args-spec-args-table`](../reference/args/args-spec-args-table.md) | 命令名以及从查询名映射到 `arg-spec` 的哈希表。 |
| `arg-binding`, [`arg-binding-p`](../reference/args/arg-binding-p.md), [`make-arg-binding`](../reference/args/make-arg-binding.md) | [`arg-binding-name`](../reference/args/arg-binding-name.md), [`arg-binding-spec`](../reference/args/arg-binding-spec.md), [`arg-binding-value`](../reference/args/arg-binding-value.md), [`arg-binding-status`](../reference/args/arg-binding-status.md) | 查询名、对应规格、原始绑定值或尚未求值的默认表达式、绑定状态。自行注入的绑定可以省略规格。 |
| `args-result`, [`args-result-p`](../reference/args/args-result-p.md), [`make-args-result`](../reference/args/make-args-result.md) | [`args-result-spec`](../reference/args/args-result-spec.md), [`args-result-input`](../reference/args/args-result-input.md), [`args-result-builtin-bindings`](../reference/args/args-result-builtin-bindings.md), [`args-result-bindings`](../reference/args/args-result-bindings.md), [`args-result-diagnostics`](../reference/args/args-result-diagnostics.md) | 命令规格、解析后的输入、调用方的内置绑定表、普通绑定表，以及词法分析与绑定阶段产生的诊断列表。 |

[导出声明](../../args/package.lisp) · [规格解析](../../args/spec.lisp) · [绑定](../../args/bind.lisp) · [查询](../../args/query.lisp) · [回归用例](../../args/test.lisp)
