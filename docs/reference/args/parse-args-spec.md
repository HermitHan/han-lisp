# `han.args:parse-args-spec`

[简体中文](parse-args-spec.zh-CN.md)

*Function*

## Syntax

```text
(han.args:parse-args-spec spec-list &optional (command "my-args")) → args-spec
```

## Description

Combine a list of `arg-spec` objects into one command specification. Compatible same-name declarations can supply complementary fields. Conflicting field values, duplicate entry spellings across names, or gaps in positional declarations signal an error. Positions must start at 0 or 1.

## Examples

Merge complementary declarations for one lookup key.

```lisp
(let* ((specs (han.args:parse-args-spec
               (mapcar #'han.args:parse-arg-spec '("(--/-j)jobs" "jobs=4"))
               "report"))
       (jobs (gethash "jobs" (han.args:args-spec-args-table specs))))
  (list (han.args:args-spec-command specs)
        (han.args:arg-spec-short-entry jobs)
        (han.args:arg-spec-default jobs)))
;; => ("report" "-j" "4")
```

Reject an option spelling shared by two names.

```lisp
(defparameter *example-option-declarations*
  (mapcar #'han.args:parse-arg-spec '("(-v)verbose?" "(-v)version?")))

(han.args:parse-args-spec *example-option-declarations*)
;; signals simple-error
```

Reject a gap in positional numbering.

```lisp
(defparameter *example-position-declarations*
  (mapcar #'han.args:parse-arg-spec '("$1" "$3")))

(han.args:parse-args-spec *example-position-declarations*)
;; signals simple-error
```

Allow a command with no declared fields.

```lisp
(let ((spec (han.args:parse-args-spec nil "version")))
  (values (han.args:args-spec-command spec)
          (hash-table-count (han.args:args-spec-args-table spec))))
;; => values ("version" 0)
```

[`han.args:parse-arg-spec`](parse-arg-spec.md) · [`han.args:args-spec`](args-spec.md) · [Source](../../../args/spec.lisp) · [Index](../README.md)
