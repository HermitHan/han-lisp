# `han.args`

[User guide](README.md) · [简体中文](args.zh-CN.md) · [Package symbol index](../reference/README.md#args)

Use `han.args` when a Lisp command accepts options, positional arguments, or blocks of arguments to pass on. Build the command specification once and bind it to different lists of strings in your program or tests. Your application decides how to display diagnostics and when to exit.

## Parse a command

The `inspect` command takes a sample name, an input file and a flag. `@filter:` opens a block with its own `--mode` argument. Supply a list with the command name first and one string per argument, as already split by the caller or shell.

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

The second value from `get-arg` distinguishes supplied input from a default. Blocks retain their original tokens. The example extracts their spelling with `arg-token-text` so they can be passed on as separate arguments.

## Declare the accepted arguments

| Declaration | Meaning |
| --- | --- |
| `!(--/-i)input` | Require a single value through `--input` or `-i`. Both `--input=` and a separate empty-string argument supply the empty string. |
| `(--/-t)threads=4` | Use the string `"4"` when omitted. Numeric conversion belongs to the caller. |
| `(--/-v)verbose?` | A flag. With this declaration, present gives `t`/`:input`, absent gives `nil`/`:missing`. |
| `(@:)filter` | Collect the tokens after `@filter:` in a list. The next slot switch closes the block. `@:` resumes top-level option parsing. |
| `$1`, `$2` | Required positional values collected at the top level. Indices must be consecutive starting at `$0` or `$1`. With `$0` as the base, it selects the first positional value. The command name is in [`args-input-raw-cmd`](../reference/args/args-input-raw-cmd.md). |
| `report=@{input}.json` | At query time, build a string from a referenced binding and literal text. A lone `@name` forwards both value and status. Concatenation has status `:default`. Cyclic references signal an error during lookup. |
| `%mode=brief` | Set visibility to `:hidden`. An application generating help can read that metadata. |

Separate long and short spellings with `/` inside parentheses. The shorthand entries `--` and `-` expand to the full name and its first character respectively. In argv a standalone `--` becomes a value with a lexer warning. Use an attached value such as `--limit=-2` to pass a leading minus to a single-value option.

## Inspect diagnostics

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

A known binding can have status `:input`, `:default`, `:missing`, or `:conflict`. An unknown name returns two `nil` values. Missing required arguments, options missing a value, and duplicate single-value options or blocks produce `:error` diagnostics. Unknown options or slots and unused positional values produce `:warning` diagnostics. Filter by `arg-diagnostic-kind`. The `arg-diagnostic-code` can be `nil` for lexer warnings.

## Functions

All names below are exported by `han.args`. Qualify them with `han.args:` when calling from another package.

| Function | Arguments | Behavior and return value |
| --- | --- | --- |
| [`parse-args-input`](../reference/args/parse-args-input.md) | `(&optional raw-input-args add-cmd)` | Prepend the list `add-cmd` to the list of argv strings. The first string becomes the command, the remainder becomes the arguments. Omitting input reads `(han.host:argv t)`. Returns an [`args-input`](../reference/args/args-input.md). |
| [`parse-arg-spec`](../reference/args/parse-arg-spec.md) | `(spec-string)` | Parse and validate one declaration. Returns an [`arg-spec`](../reference/args/arg-spec.md). |
| [`parse-args-spec`](../reference/args/parse-args-spec.md) | `(spec-list &optional command)` | Combine a list of `arg-spec` objects into an [`args-spec`](../reference/args/args-spec.md). The command label defaults to `"my-args"`. Compatible declarations with the same name merge. Incompatible fields or duplicate option spellings across names signal an error. |
| [`bind-args`](../reference/args/bind-args.md) | `(args-spec args-input &optional builtin-table)` | Bind values and collect diagnostics in an [`args-result`](../reference/args/args-result.md). If supplied, `builtin-table` must be a hash table mapping names to [`arg-binding`](../reference/args/arg-binding.md) objects with statuses. Omitting it creates an empty table. Use `equalp` for case-insensitive string lookup. |
| [`get-arg`](../reference/args/get-arg.md) | `(name-or-spec args-result &optional history)` | Accepts a spec string, an `arg-spec`, or an integer position. Returns value and status. Built-in bindings take precedence. Leave `history` at its default when calling from an application. It tracks references during recursive queries. |
| [`arg-key-equal`](../reference/args/arg-key-equal.md) | `(x y)` | Compare two strings with `string-equal`, other keys with `eql`. |
| [`help`](../reference/args/help.md) | `(&optional stream)` | Return package help as a string and print it to `stream` (default `*standard-output*`). Pass `nil` to obtain the string silently. |
| [`version`](../reference/args/version.md) | `(&optional stream)` | Return the version string. Prints the package name and version to `stream` unless it is `nil`. |

## Inspect the records

The parsing and binding functions create these structures for you. Each predicate takes one object and each accessor takes an instance of the corresponding type. For manual construction, pass keyword arguments named after the fields. For example, `make-arg-binding` accepts `:name`, `:spec`, `:value`, and `:status`.

| Type / predicate / constructor | Accessors (in description order) | Fields |
| --- | --- | --- |
| [`arg-token`](../reference/args/arg-token.md), [`arg-token-p`](../reference/args/arg-token-p.md), [`make-arg-token`](../reference/args/make-arg-token.md) | [`arg-token-kind`](../reference/args/arg-token-kind.md), [`arg-token-text`](../reference/args/arg-token-text.md), [`arg-token-value`](../reference/args/arg-token-value.md), [`arg-token-extra`](../reference/args/arg-token-extra.md), [`arg-token-position`](../reference/args/arg-token-position.md) | Classification (`:long-option`, `:short-option`, `:slot-switch`, `:value`), original spelling, normalized name or value, text following the first `=` on an option (or `nil`), and zero-based argv position after the command. |
| [`arg-segment`](../reference/args/arg-segment.md), [`arg-segment-p`](../reference/args/arg-segment-p.md), [`make-arg-segment`](../reference/args/make-arg-segment.md) | [`arg-segment-slot`](../reference/args/arg-segment-slot.md), [`arg-segment-positions`](../reference/args/arg-segment-positions.md) | Slot name (`nil` for the top level) and a list of indices into the token vector. The switch itself is excluded. |
| `args-input`, [`args-input-p`](../reference/args/args-input-p.md), [`make-args-input`](../reference/args/make-args-input.md) | `args-input-raw-cmd`, [`args-input-raw-argv`](../reference/args/args-input-raw-argv.md), [`args-input-tokens`](../reference/args/args-input-tokens.md), [`args-input-segments`](../reference/args/args-input-segments.md), [`args-input-diagnostics`](../reference/args/args-input-diagnostics.md) | Command string, argument string list after the command, token vector, ordered segment list, and lexer diagnostics. |
| [`arg-diagnostic`](../reference/args/arg-diagnostic.md), [`arg-diagnostic-p`](../reference/args/arg-diagnostic-p.md), [`make-arg-diagnostic`](../reference/args/make-arg-diagnostic.md) | [`arg-diagnostic-kind`](../reference/args/arg-diagnostic-kind.md), [`arg-diagnostic-code`](../reference/args/arg-diagnostic-code.md), [`arg-diagnostic-message`](../reference/args/arg-diagnostic-message.md), [`arg-diagnostic-position`](../reference/args/arg-diagnostic-position.md) | Severity (`:error` or `:warning`), optional machine-readable code, message, and argv index when available. |
| `arg-spec`, [`arg-spec-p`](../reference/args/arg-spec-p.md), [`make-arg-spec`](../reference/args/make-arg-spec.md) | [`arg-spec-name`](../reference/args/arg-spec-name.md), [`arg-spec-long-entry`](../reference/args/arg-spec-long-entry.md), [`arg-spec-short-entry`](../reference/args/arg-spec-short-entry.md), [`arg-spec-slot-entry`](../reference/args/arg-spec-slot-entry.md), [`arg-spec-arity`](../reference/args/arg-spec-arity.md), [`arg-spec-required`](../reference/args/arg-spec-required.md), [`arg-spec-visibility`](../reference/args/arg-spec-visibility.md), [`arg-spec-default`](../reference/args/arg-spec-default.md) | Lookup name (a string or positional integer), long/short/slot spellings including delimiters, arity (`:single`, `:flag`, `:block`, `:position`), required flag, `:public` or `:hidden` visibility, and parsed default. A default can be a string, `nil`, a `:query` form or a `:concat` form. |
| `args-spec`, [`args-spec-p`](../reference/args/args-spec-p.md), [`make-args-spec`](../reference/args/make-args-spec.md) | [`args-spec-command`](../reference/args/args-spec-command.md), [`args-spec-args-table`](../reference/args/args-spec-args-table.md) | Command label and a hash table mapping lookup names to `arg-spec` objects. |
| `arg-binding`, [`arg-binding-p`](../reference/args/arg-binding-p.md), [`make-arg-binding`](../reference/args/make-arg-binding.md) | [`arg-binding-name`](../reference/args/arg-binding-name.md), [`arg-binding-spec`](../reference/args/arg-binding-spec.md), [`arg-binding-value`](../reference/args/arg-binding-value.md), [`arg-binding-status`](../reference/args/arg-binding-status.md) | Lookup name, originating spec, raw bound value or unevaluated default, and binding status. An injected binding may omit the spec. |
| `args-result`, [`args-result-p`](../reference/args/args-result-p.md), [`make-args-result`](../reference/args/make-args-result.md) | [`args-result-spec`](../reference/args/args-result-spec.md), [`args-result-input`](../reference/args/args-result-input.md), [`args-result-builtin-bindings`](../reference/args/args-result-builtin-bindings.md), [`args-result-bindings`](../reference/args/args-result-bindings.md), [`args-result-diagnostics`](../reference/args/args-result-diagnostics.md) | Command spec, parsed input, caller-provided binding table, ordinary binding table, and the list of lexer and binder diagnostics. |

[Exports](../../args/package.lisp) · [Spec parser](../../args/spec.lisp) · [Binder](../../args/bind.lisp) · [Query implementation](../../args/query.lisp) · [Regression cases](../../args/test.lisp)
