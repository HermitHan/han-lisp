# `han.args:get-arg`

[简体中文](get-arg.zh-CN.md)

*Function*

## Syntax

```text
(han.args:get-arg name-or-spec args-result &optional (history nil)) → value, status
```

## Description

Look up a string declaration or name, an `arg-spec`, or an integer position. Built-in bindings take precedence. An unknown key yields `nil, nil`. A stored argument normally yields its value and status. A default containing just a reference forwards the target's values, while concatenating text produces a string with status `:default`. Recursive lookup uses `history` to detect cycles and signals an error on a cycle. Applications can omit it.

## Examples

Follow a reference to user input and look up an unknown key.

```lisp
(let* ((specs (han.args:parse-args-spec
               (mapcar #'han.args:parse-arg-spec '("(--)name" "alias=@name"))))
       (result (han.args:bind-args
                specs (han.args:parse-args-input '("demo" "--name=ada")))))
  (list (multiple-value-list (han.args:get-arg "alias" result))
        (multiple-value-list (han.args:get-arg "unknown" result))))
;; => (("ada" :input) (nil nil))
```

Resolve a positional key when the caller starts counting at zero.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("$0" "$1")))
         (han.args:parse-args-input '("demo" "first" "second")))))
  (han.args:get-arg 1 result))
;; => values ("second" :input)
```

Differentiate a supplied empty option from an unset option.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)name")))
         (han.args:parse-args-input '("demo" "--name=")))))
  (han.args:get-arg "name" result))
;; => values ("" :input)
```

Resolve a literal default for an omitted option.

```lisp
(let ((result
        (han.args:bind-args
         (han.args:parse-args-spec
          (mapcar #'han.args:parse-arg-spec '("(--)jobs=4")))
         (han.args:parse-args-input '("demo")))))
  (han.args:get-arg "jobs" result))
;; => values ("4" :default)
```

Distinguish a conflicting option from an unknown key: neither has a usable value, but only the repeated option has the status `:conflict`.

```lisp
(let* ((spec (han.args:parse-args-spec
              (list (han.args:parse-arg-spec "(--/-n)name=world")) "greet"))
       (input (han.args:parse-args-input '("greet" "-n" "Ada" "--name" "Lin")))
       (result (han.args:bind-args spec input)))
  (han.args:get-arg "name" result))
;; => values (NIL :CONFLICT)
```

Detect cyclic references at lookup time.

```lisp
(defparameter *example-cyclic-result*
  (han.args:bind-args
   (han.args:parse-args-spec
    (mapcar #'han.args:parse-arg-spec '("left=@right" "right=@left")))
   (han.args:parse-args-input '("demo"))))

(han.args:get-arg "left" *example-cyclic-result*)
;; signals simple-error
```

[`han.args:bind-args`](bind-args.md) · [`han.args:arg-binding-status`](arg-binding-status.md) · [Source](../../../args/query.lisp) · [Index](../README.md)
