# han.path

[用户手册](README.zh-CN.md) · [English](path.md) · [本包符号参考](../reference/README.md#path)

用 `han.path` 拼接文件名、计算相对于项目目录的路径，或查询磁盘上的目录。以下例子采用 Unix 路径语法。表中函数均属于 `han.path`。

## 为报告生成路径

调用方给出的目录名可能有或没有末尾斜杠。把它转成目录 pathname，接上年份和文件名，再计算适合写入项目清单的相对名称。此处显式提供了绝对基准目录，可以在目录和文件尚未创建时计算。

```lisp
(let* ((root (han.path:directory-pathname "/work/reports"))
       (file (han.path:join-path root "2026" "summary.json")))
  (list (han.path:->namestring file)
        (han.path:->namestring (han.path:relative-path file root))
        (han.path:->namestring (han.path:parent-directory-pathname file))))
;; => ("/work/reports/2026/summary.json" "2026/summary.json" "/work/reports/2026/")
```

| 操作 | 返回值与语义 |
| --- | --- |
| [`->pathname x`](../reference/path/to-pathname.md)、[`->namestring x`](../reference/path/to-namestring.md) | 接受字符串或 pathname。前者返回目录分量经过规范化的 pathname，后者返回其名称字符串。字符串表示遵循当前 Lisp 实现的路径语法。 |
| [`directory-pathname-p x`](../reference/path/directory-pathname-p.md) | 判断路径的形式。目录 pathname 的 name 和 type 分量均为空。 |
| [`directory-pathname x`](../reference/path/directory-pathname.md) | 返回目录 pathname，把文件形式的最后一个分量视为目录名。例如 `"a.txt"` 会变为 `"a.txt/"`。 |
| [`parent-directory-pathname x`](../reference/path/parent-directory-pathname.md) | 去掉文件 pathname 的 name 和 type，得到所在目录。传入目录 pathname 时返回该目录本身，例如 `"/work/reports/"` 得到 `#P"/work/reports/"`。 |
| [`join-path base &rest parts`](../reference/path/join-path.md) | 返回 pathname，从左到右合并各段，每一步都把前一步结果当作目录。中途遇到绝对路径时，前面的目录可能被替换。 |
| [`absolute-pathname-p x`](../reference/path/absolute-pathname-p.md) | 检查目录分量是否以 `:absolute` 开头。 |
| [`absolute-pathname x &optional base`](../reference/path/absolute-pathname.md) | 输入是绝对路径时返回相应 pathname。相对输入与作为目录的 `base` 合并，需要默认基准时使用 [Lisp 工作目录](../reference/host/working-directory-pathname.md)。需要绝对结果时应提供绝对基准。 |
| [`relative-path target &optional base`](../reference/path/relative-path.md) | 先分别按当前目录解析两个参数，再计算从 `base` 到 `target` 的 pathname，需要时包含向上返回的分量。相对路径保留其 host 和 device；两条路径的 host 或 device 不同时，或逻辑路径需要上行时，返回绝对目标。如果希望把相对目标解释成某个基准下的文件，先用 `absolute-pathname` 和该基准合并。 |

## 查询和操作磁盘文件

如果只想判断路径写成什么形式，检查 pathname 的分量即可。要取得磁盘上实际存在的文件，使用存在性查询。成功时得到的 pathname 可直接传给下一个函数。

```lisp
(list (han.path:directory-pathname-p "/bin/sh")
      (pathnamep (han.path:file-exists-p "/bin/sh"))
      (pathnamep (han.path:directory-exists-p "/bin")))
;; => (NIL T T)
```

| 操作 | 返回值与效果 |
| --- | --- |
| [`file-exists-p path`](../reference/path/file-exists-p.md)、[`directory-exists-p path`](../reference/path/directory-exists-p.md) | 分别返回探测到的文件或目录 pathname，未探测到匹配项时返回 `nil`。 |
| [`directory-files directory`](../reference/path/directory-files.md)、[`subdirectories directory`](../reference/path/subdirectories.md) | 分别列出直接子文件和直接子目录，元素为 pathname。需要固定顺序时由调用方排序。 |
| [`copy-file source target`](../reference/path/copy-file.md) | 按字节复制，创建缺少的父目录，覆盖已有目标文件，返回传入的 target。 |
| [`delete-directory-tree directory &key (validate t) (if-does-not-exist :ignore)`](../reference/path/delete-directory-tree.md) | 递归删除已有目录，成功返回 `t`。默认校验会拒绝文件系统根目录。目标缺失时 `:ignore` 返回 `nil`，`:error` 报错。实现调用 Unix 的 `rm`。 |
| [`temporary-directory`](../reference/path/temporary-directory.md) | 依次从 `TMPDIR`、`TEMP`、`TMP`、`/tmp/` 选取临时目录，返回目录 pathname。创建临时文件时由调用方选择唯一的子路径。 |
| [`help &optional stream`](../reference/path/help.md)、[`version &optional stream`](../reference/path/version.md) | 返回帮助文本或版本字符串，默认同时写到 `*standard-output*`。传 `nil` 只取字符串。 |

磁盘操作委托给宿主层。文件锁和 UTF-8 追加写入见 [han.host](host.zh-CN.md)。导出列表和更多例子见[包定义](../../path/package.lisp)与[测试](../../path/test.lisp)。
