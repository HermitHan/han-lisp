# `han.host:find-executable`

*Function · 函数*

## Syntax · 语法

```text
(han.host:find-executable program) → matching namestring(s) or nil
```

## Description · 说明

Accepts a nonempty string. If it contains a slash or backslash, checks that path first and returns its namestring immediately on a hit. If the direct lookup misses or the name has no separator, searches the colon-separated `PATH` in order. An empty entry denotes the current directory. The search then continues through `/usr/local/bin`, `/usr/bin`, `/bin`, `/usr/sbin`, `/sbin`, `/opt/homebrew/bin`, and `/opt/local/bin`. Each distinct file namestring is returned as a separate value. An invalid input or a miss returns `nil`. The lookup checks file existence alone. Execute permission is determined when a process actually starts.

接受非空字符串。如果字符串含有斜杠或反斜杠，先按给定路径查找，命中即返回该文件的名称字符串。直接查找失败或名称无分隔符时，按顺序搜索以冒号分隔的 `PATH`，空目录项表示当前目录。然后依次搜索上述七个后备目录。不同的文件名称字符串按命中顺序作为多个值返回。输入无效或没有匹配时返回 `nil`。查找只检查文件存在性，能否执行在实际启动时确定。

## Examples · 示例

Collect all matches for the system shell. The first element is the path an ordinary single-value call returns.

收集系统 shell 的全部匹配项。列表首项等于普通单值调用取得的路径。

```lisp
(let ((paths (multiple-value-list (han.host:find-executable "sh"))))
  (and (every #'stringp paths)
       (equal paths (remove-duplicates paths :test #'string=))
       (equal (first paths) (han.host:find-executable "sh"))))
;; => T
```

Look up a temporary regular file directly. The call returns exactly one value.

直接查找一个临时普通文件，此调用只返回一个值。

```lisp
(uiop:with-temporary-file (:pathname file)
  (equal (multiple-value-list (han.host:find-executable (namestring file)))
         (list (namestring (truename file)))))
;; => T
```

An empty program name has no match.

空程序名不会命中。

```lisp
(han.host:find-executable "")
;; => values (NIL)
```

[`han.os:find-executable`](../os/find-executable.md) · [`han.host:shell-command-argv`](shell-command-argv.md) · [common.lisp](../../../host/common.lisp) · [Index · 索引](../README.md)
