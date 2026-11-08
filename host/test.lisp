(in-package :han.test)

;;;; ============================================================
;;;; han.host tests
;;;; ============================================================

(defun non-empty-string-p (x)
  (and (stringp x)
       (> (length x) 0)))

(defun string-or-nil-p (x)
  (or (null x) (stringp x)))

(defun integer-or-nil-p (x)
  (or (null x) (integerp x)))

(defun stream-or-nil-p (x)
  (or (null x) (streamp x)))

(defun %han-host-temp-file (prefix type)
  (let ((symbol (find-symbol "%HOST-TEMP-FILE" "HAN.HOST")))
    (unless (and symbol (fboundp symbol))
      (error "Can't find HAN.HOST::%HOST-TEMP-FILE."))
    (funcall symbol prefix type)))

(defun %unique-string-list-p (strings)
  (= (length strings)
     (length (remove-duplicates strings :test #'string=))))

(unless (fboundp 'signal-error-p)
  (defun signal-error-p (thunk)
    (handler-case
        (progn
          (funcall thunk)
          nil)
      (error () t))))

(defun %han-host-test-directory ()
  (merge-pathnames
   (make-pathname :directory
                  (list :relative
                        (format nil "han-host-test-~A-~A"
                                (get-universal-time)
                                (random 1000000)))
                  :name nil
                  :type nil)
   (han.host:temporary-directory)))

(deftest test-han-host-help-and-version ()
  (let ((help-string (han.host:help nil)))
    (check-true (stringp help-string))
    (check-true (search "han.host" help-string))
    (check-true (search "standard-error-terminal-p" help-string))
    (check-true (search "fd 2" help-string))
    (check-true (search "closed stderr returns NIL" help-string))
    (check-true (search "run-program" help-string)))
  (check-equal "0.1.0" (han.host:version nil)))

(deftest test-host-argv ()
  (let ((argv (han.host:argv)))
    (check-equal (listp argv) t)
    ;; argv 里的每一项通常都应是 string
    (check-equal
     (every #'stringp argv)
     t)))

(deftest test-host-configure-runtime-io ()
  (check-true (han.host:prepare-runtime-io))
  (check-true (han.host:configure-runtime-io)))

(deftest test-host-working-directory-resolution-and-failure ()
  (let ((root (%han-host-test-directory)))
    (unwind-protect
         (progn
           (ensure-directories-exist (merge-pathnames "anchor" root))
           (let ((*default-pathname-defaults* root))
             (check-equal (namestring (truename root))
                          (namestring (han.host:working-directory-pathname)))
             (check-equal (namestring (truename root)) (han.host:cwd)))
           (let ((*default-pathname-defaults* (merge-pathnames "missing/" root)))
             (check-error (error) (han.host:working-directory-pathname))
             (check-false (han.host:cwd))))
      (han.host:delete-directory-tree root))))

(deftest test-host-shell-command-argv-preserves-command-and-shell ()
  (let ((command "printf '%s' 'with spaces; and a dollar $'")
        (explicit #P"/bin/sh"))
    (check-equal (list explicit "-c" command)
                 (han.host:shell-command-argv command explicit))
    (check-equal (list (or (han.host:find-executable "bash")
                           (han.host:find-executable "sh"))
                       "-c" command)
                 (han.host:shell-command-argv command))
    (check-error (simple-error)
      (han.host:shell-command-argv command (%han-host-temp-file "missing-shell" nil)))))

(deftest test-host-unicode-scalar-boundaries ()
  (dolist (bad '(nil 1/2 -1 #xD800 #xDBFF #xDC00 #xDFFF #x110000))
    (check-false (han.host:unicode-scalar-char bad)))
  (check-equal #x41 (han.host:char-unicode-scalar #\A))
  (dolist (code '(#xD7FF #xE000 #x1F600))
    (check-equal code (han.host:char-unicode-scalar (han.host:unicode-scalar-char code))))
  (check-error (type-error) (han.host:char-unicode-scalar #x41)))

(define-condition %host-test-unprintable-error (error) ()
  (:report (lambda (condition stream)
             (declare (ignore condition stream))
             (error "report failed"))))

(deftest test-host-cli-boundary-preserves-values ()
  (check-equal '(42 :second)
               (multiple-value-list
                (han.host::%with-cli-error-boundary ("[TEST]")
                  (values 42 :second)))))

(deftest test-host-cli-boundary-reports-error ()
  (let ((*standard-output* (make-string-output-stream))
        (*error-output* (make-string-output-stream)))
    (flet ((han.host:quit (&optional (code 0)) (throw 'cli-exit code)))
      (check-equal 1
                   (catch 'cli-exit
                     (han.host::%with-cli-error-boundary ("[TEST]")
                       (error "expected failure")))))
    (check-equal (format nil "[TEST] expected failure~%")
                 (get-output-stream-string *error-output*))
    (check-equal "" (get-output-stream-string *standard-output*))))

(deftest test-host-cli-boundary-tolerates-report-failure ()
  (let ((*standard-output* (make-string-output-stream))
        (*error-output* (make-string-output-stream)))
    (flet ((han.host:quit (&optional (code 0)) (throw 'cli-exit code)))
      (check-equal 1
                   (catch 'cli-exit
                     (han.host::%with-cli-error-boundary ("[TEST]")
                       (error '%host-test-unprintable-error)))))
    (check-equal "" (get-output-stream-string *standard-output*))))

(deftest test-host-cli-boundary-tolerates-unwritable-stderr ()
  (let ((*standard-output* (make-string-output-stream))
        (*error-output* (make-string-input-stream "")))
    (flet ((han.host:quit (&optional (code 0)) (throw 'cli-exit code)))
      (check-equal 1
                   (catch 'cli-exit
                     (han.host::%with-cli-error-boundary ("[TEST]")
                       (error "expected failure")))))
    (check-equal "" (get-output-stream-string *standard-output*))))

(deftest test-host-cli-boundary-preserves-warnings-and-conditions ()
  (let ((warnings 0) (conditions 0))
    (handler-bind
        ((warning (lambda (condition)
                    (incf warnings)
                    (muffle-warning condition)))
         (simple-condition (lambda (condition)
                             (unless (typep condition 'warning)
                               (incf conditions)))))
      (check-equal :continued
                   (han.host::%with-cli-error-boundary ("[TEST]")
                     (warn "expected warning")
                     (signal 'simple-condition :format-control "notice")
                     :continued)))
    (check-equal 1 warnings)
    (check-equal 1 conditions)))

#+sbcl
(deftest test-host-cli-boundary-interrupt-exits-without-debugger ()
  (let ((*error-output* (make-string-output-stream)))
    (flet ((han.host:quit (&optional (code 0)) (throw 'cli-exit code)))
      (check-equal 1
                   (catch 'cli-exit
                     (han.host::%with-cli-error-boundary ("[TEST]")
                       (signal 'sb-sys:interactive-interrupt)))))
    (check-equal (format nil "[TEST] Interrupted.~%")
                 (get-output-stream-string *error-output*))))

(deftest test-host-full-character-output-string ()
  (let* ((character (code-char #x9879))
         (string
           (han.host:with-character-output-to-string (out)
             (write-string "probe-" out)
             (write-char character out))))
    (check-equal (char string (1- (length string))) character)
    (check-true (typep string 'string))))

(deftest test-host-standard-input-terminal-p-returns-boolean ()
  (check-true
   (member (han.host:standard-input-terminal-p) '(nil t))))

(deftest test-host-standard-error-terminal-p-returns-boolean ()
  (check-true
   (member (han.host:standard-error-terminal-p) '(nil t)))
  (check-equal :external
               (nth-value 1 (find-symbol "STANDARD-ERROR-TERMINAL-P" :han.host))))

(deftest test-host-standard-error-terminal-p-has-no-stream-effects ()
  (with-input-from-string (*standard-input* "unread")
    (let ((*standard-output* (make-string-output-stream))
          (*error-output* (make-string-output-stream)))
      (check-true (member (han.host:standard-error-terminal-p) '(nil t)))
      (check-equal "" (get-output-stream-string *standard-output*))
      (check-equal "" (get-output-stream-string *error-output*))
      (close *error-output*)
      (check-true (member (han.host:standard-error-terminal-p) '(nil t)))
      (check-equal "unread" (read-line *standard-input*)))))

#+lispworks
(deftest test-host-runtime-output-interactivity-follows-descriptor ()
  (let ((stream (han.host::%lispworks-runtime-output 2)))
    (check-equal (han.host:standard-error-terminal-p)
                 (not (null (interactive-stream-p stream))))
    (check-equal 0 (han.host::%lispworks-output-line-column stream)))
  (let ((stream (han.host::%lispworks-runtime-output -1)))
    (check-false (interactive-stream-p stream))
    (close stream)
    (check-false (interactive-stream-p stream)))
  (let ((*error-output* (make-string-output-stream)))
    (check-false (interactive-stream-p *error-output*))
    (check-equal "" (get-output-stream-string *error-output*))))

(deftest test-host-run-program-basic ()
  (let ((process (han.host:run-program "/bin/sh"
                                       :arguments (list "-c" "printf hello"))))
    (check-equal (null process) nil)
    (check-equal
     (stream-or-nil-p (han.host:host-process-output-stream process))
     t)
    (check-equal
     (stream-or-nil-p (han.host:host-process-error-stream process))
     t)
    (check-equal
     (integer-or-nil-p (han.host:host-process-pid process))
     t)
    (han.host:process-wait process)
    (check-equal
     (integerp (han.host:process-exit-code process))
     t)
    (check-equal
     (han.host:process-exit-code process)
     0)
    (han.host:process-close process)))

(deftest test-host-run-program-nonzero-exit ()
  (let ((process (han.host:run-program "/bin/sh"
                                       :arguments (list "-c" "exit 7"))))
    (han.host:process-wait process)
    (check-equal (han.host:process-exit-code process) 7)
    (han.host:process-close process)))

#+(or sbcl lispworks)
(deftest test-host-child-terminated-by-sigterm ()
  (let* ((command '("/bin/sh" "-c" "printf out; printf err >&2; kill -TERM $$"))
         (expected #+sbcl 15 #+lispworks 143))
    (check-equal (list "out" "err" expected)
                 (multiple-value-list (han.host:run-program-sync command)))
    (check-error (simple-error)
      (han.host:run-program-sync command :ignore-error-status nil))
    (let ((child (han.host:run-program (first command) :arguments (rest command))))
      (unwind-protect
           (progn
             (han.host:process-wait child)
             (check-equal :exited (han.host:process-status child))
             (check-equal expected (han.host:process-exit-code child)))
        (han.host:process-close child)))))

(deftest test-host-run-program-sync-default-input-is-eof ()
  (multiple-value-bind (out err code)
      (han.host:run-program-sync
       (list "/bin/sh" "-c" "cat")
       :output :string
       :error-output :string
       :ignore-error-status t)
    (check-equal code 0)
    (check-equal out "")
    (check-equal err "")))

(deftest test-host-run-program-sync-input-t-uses-standard-input ()
  (with-input-from-string (*standard-input* "abc")
    (multiple-value-bind (out err code)
        (han.host:run-program-sync
         (list "/bin/sh" "-c" "cat")
         :input t
         :output :string
         :error-output :string
         :ignore-error-status t)
      (check-equal code 0)
      (check-equal out "abc")
      (check-equal err ""))))

(deftest test-host-run-program-sync-output-t-replays-to-standard-output ()
  (let ((captured
          (with-output-to-string (*standard-output*)
            (multiple-value-bind (out err code)
                (han.host:run-program-sync
                 (list "/bin/sh" "-c" "printf replay")
                 :output t
                 :error-output :string
                 :ignore-error-status t)
              (check-equal code 0)
              (check-equal out nil)
              (check-equal err "")))))
    (check-equal captured "replay")))

(deftest test-host-sync-caller-streams-and-nonzero-exit ()
  (with-input-from-string (in "skip:payload" :start 5)
    (let ((out (make-string-output-stream))
          (err (make-string-output-stream)))
      (unwind-protect
           (progn
             (check-equal '(nil nil 9)
                          (multiple-value-list
                           (han.host:run-program-sync
                            '("/bin/sh" "-c" "cat; printf diagnostic >&2; exit 9")
                            :input in :output out :error-output err)))
             (check-true (every #'open-stream-p (list in out err)))
             (check-equal :eof (read-char in nil :eof))
             (check-equal "payload" (get-output-stream-string out))
             (check-equal "diagnostic" (get-output-stream-string err)))
        (close out)
        (close err))))
  (check-error (simple-error)
    (han.host:run-program-sync '("/bin/sh" "-c" "exit 9") :ignore-error-status nil)))

(deftest test-host-run-program-output ()
  (let ((process (han.host:run-program "/bin/sh"
                                       :arguments (list "-c" "printf hello"))))
    (han.host:process-wait process)
    (let ((out (han.host:host-process-output-stream process)))
      (check-equal (streamp out) t)
      (check-equal (read-line out nil "") "hello"))
    (han.host:process-close process)))

(deftest test-host-run-program-error-output ()
  (let ((process (han.host:run-program "/bin/sh"
                                       :arguments (list "-c" "printf oops 1>&2"))))
    (han.host:process-wait process)
    (let ((err (han.host:host-process-error-stream process)))
      (check-equal (streamp err) t)
      (check-equal (read-line err nil "") "oops"))
    (han.host:process-close process)))

(deftest test-host-run-program-both-streams ()
  (let ((process (han.host:run-program "/bin/sh"
                                       :arguments (list "-c" "printf out; printf err 1>&2"))))
    (han.host:process-wait process)
    (let ((out (han.host:host-process-output-stream process))
          (err (han.host:host-process-error-stream process)))
      (check-equal (read-line out nil "") "out")
      (check-equal (read-line err nil "") "err"))
    (han.host:process-close process)))

(deftest test-host-process-close-safe-after-wait ()
  (let ((process (han.host:run-program "/bin/sh"
                                       :arguments (list "-c" "printf ok"))))
    (han.host:process-wait process)
    (check-equal
     (signal-error-p (lambda () (han.host:process-close process)))
     nil)))

(deftest test-host-invalid-program-error ()
  (let ((file (namestring (%han-host-temp-file "han-not-executable" nil))))
    (check-error (error) (han.host:run-program file))
    (check-error (error) (han.host:run-program-sync (list file) :ignore-error-status t))
    (unwind-protect
         (progn
           (with-open-file (out file :direction :output :if-exists :error)
             (write-line "regular file" out))
           (han.host:run-program-sync (list "/bin/chmod" "600" file) :ignore-error-status nil)
           (check-true (han.host:find-executable file))
           (check-error (error)
             (han.host:run-program-sync (list file) :ignore-error-status t)))
      (when (probe-file file) (delete-file file)))))

(deftest test-host-temp-file-generates-unique-non-existing-paths ()
  (let ((names nil))
    (loop repeat 100 do
      (let ((path (%han-host-temp-file "han-host-output" "tmp")))
        (check-false (han.host:file-exists-p path))
        (check-false (han.host:directory-exists-p path))
        (push (namestring path) names)))
    (check-true (%unique-string-list-p names))))

(deftest test-host-temp-file-unique-with-repeated-image-state ()
  ;; Regression test for SBCL saved-image style collisions: two separately
  ;; started images can share gensym/random/time state, so temp names must use
  ;; process/OS-level entropy instead of only CL image-local state.
  (let ((seed (make-random-state t))
        (names nil))
    (loop repeat 40 do
      (let ((*gensym-counter* 130)
            (*random-state* (make-random-state seed)))
        (push (namestring (%han-host-temp-file "han-host-output" "tmp"))
              names)))
    (check-true (%unique-string-list-p names))))

(deftest test-host-current-process-id ()
  (let ((pid (han.host:current-process-id)))
    (check-true (integerp pid))
    (check-true (> pid 0))))

(deftest test-host-exclusive-file-lock ()
  (let* ((root (%han-host-test-directory))
         (file (merge-pathnames "logs/记录.lock" root))
         (entered-again nil))
    (unwind-protect
         (progn
           (check-equal
            '(:first :second)
            (multiple-value-list
             (han.host:call-with-exclusive-file-lock
              file
              (lambda ()
                ;; A separately opened descriptor must contend even in this process.
                (check-true
                 (signal-error-p
                  (lambda ()
                    (han.host:call-with-exclusive-file-lock
                     file (lambda () (setf entered-again t)) :timeout 0))))
                (check-false entered-again)
                (values :first :second)))))
           (check-equal
            :unwound
            (catch 'escape
              (han.host:call-with-exclusive-file-lock
               file (lambda () (throw 'escape :unwound)) :timeout 0)))
           (check-true (han.host:file-exists-p file))
           (check-equal :reacquired
                        (han.host:call-with-exclusive-file-lock
                         file (lambda () :reacquired) :timeout 0)))
      (when (han.host:directory-exists-p root)
        (han.host:delete-directory-tree root)))))

(deftest test-open-utf8-file-bytes-values-and-cleanup ()
  (let ((file (%han-host-temp-file "han-utf8" "txt"))
        (sample (map 'string #'han.host:unicode-scalar-char '(#x6C49 #x1F600)))
        stream)
    (unwind-protect
         (progn
           (check-equal '(42 :written)
             (multiple-value-list
              (han.host:with-open-utf8-file (out file :direction :output
                                                      :if-exists :error)
                (write-string sample out)
                (values 42 :written))))
           (with-open-file (in file :element-type '(unsigned-byte 8))
             (check-equal '(#xE6 #xB1 #x89 #xF0 #x9F #x98 #x80)
               (loop for byte = (read-byte in nil nil) while byte collect byte)))
           (han.host:with-open-utf8-file (in file)
             (check-equal sample (read-line in)))
           (check-error (simple-error)
             (han.host:with-open-utf8-file (in file)
               (setf stream in)
               (error "leave the body")))
           (check-true stream)
           (check-false (open-stream-p stream)))
      (when (probe-file file) (delete-file file)))))

(deftest test-host-append-utf8-line ()
  (let* ((root (%han-host-test-directory))
         (file (merge-pathnames "logs/history.jsonl" root))
         (unicode-line
           (han.host:with-character-output-to-string (out)
             (write-string "unicode-" out)
             (write-char (code-char #x9879) out))))
    (unwind-protect
         (progn
           (han.host:append-utf8-line file "first")
           (han.host:append-utf8-line file unicode-line)
           (with-open-file (in file
                               :direction :input
                               :element-type 'character
                               :external-format :utf-8)
             (check-equal (read-line in nil nil) "first")
             (check-equal (read-line in nil nil) unicode-line)
             (check-equal (read-line in nil :eof) :eof)))
      (ignore-errors
        (when (han.host:directory-exists-p root)
          (han.host:delete-directory-tree root))))))

(deftest test-host-lock-and-append-literal-os-path ()
  (let* ((root (%han-host-test-directory))
         (path (concatenate 'string (namestring root) "dir[*]\\?/bad[.jsonl"))
         (lock (concatenate 'string path ".lock")))
    (unwind-protect
         (progn
           (han.host:call-with-exclusive-file-lock
            lock (lambda () (han.host:append-utf8-line path "literal")))
           ;; Read via the OS, independently of either Lisp's pathname parser.
           (multiple-value-bind (out err code)
               (han.host:run-program-sync (list "/bin/cat" path))
             (check-equal 0 code)
             (check-equal "" err)
             (check-equal (format nil "literal~%") out))
           (check-equal 0 (nth-value 2 (han.host:run-program-sync
                                        (list "/bin/test" "-f" lock)))))
      (when (han.host:directory-exists-p root)
        (han.host:delete-directory-tree root)))))

(deftest test-host-run-program-sync-unicode-path-argument ()
  (let* ((root (%han-host-test-directory))
         (leaf (with-output-to-string (out nil :element-type 'character)
                 (write-string "probe-" out)
                 (write-char (code-char #x9879) out)))
         (file (merge-pathnames leaf root)))
    (unwind-protect
         (progn
           (ensure-directories-exist file)
           (with-open-file (out file
                                :direction :output
                                :if-exists :supersede
                                :if-does-not-exist :create
                                :element-type '(unsigned-byte 8))
             (write-byte 120 out))
           (multiple-value-bind (stdout stderr code)
               (han.host:run-program-sync
                (list "/bin/chmod" "+x" (namestring file))
                :output :string
                :error-output :string
                :ignore-error-status t)
             (check-equal stdout "")
             (check-equal stderr "")
             (check-equal code 0)))
      (ignore-errors
        (when (han.host:directory-exists-p root)
          (han.host:delete-directory-tree root))))))

(deftest test-host-file-directory-helpers-without-uiop ()
  (let* ((root (%han-host-test-directory))
         (file (merge-pathnames "a.txt" root))
         (copy (merge-pathnames "copy/a.txt" root))
         (subdir (merge-pathnames "sub/" root))
         (nested (merge-pathnames "b" subdir)))
    (unwind-protect
         (progn
           (ensure-directories-exist file)
           (with-open-file (out file :direction :output
                                     :if-exists :supersede
                                     :if-does-not-exist :create)
             (write-string "hello" out))
           (ensure-directories-exist nested)
           (with-open-file (out nested :direction :output
                                       :if-exists :supersede
                                       :if-does-not-exist :create)
             (write-string "world" out))
           (check-true (han.host:file-exists-p file))
           (check-true (han.host:directory-exists-p root))
           (check-true (han.host:directory-exists-p subdir))
           (check-true
            (find "a.txt"
                  (mapcar #'file-namestring
                          (han.host:directory-files root))
                  :test #'equal))
           (check-false
            (find "b"
                  (mapcar #'file-namestring
                          (han.host:directory-files root))
                  :test #'equal))
           (check-equal
            (mapcar #'file-namestring
                    (han.host:directory-files subdir))
            '("b"))
           (check-true
            (find "sub"
                  (mapcar (lambda (path)
                            (car (last (pathname-directory path))))
                          (han.host:subdirectories root))
                  :test #'equal))
           (check-equal
            (every (lambda (path)
                     (and (null (pathname-name path))
                          (null (pathname-type path))))
                   (han.host:subdirectories root))
            t)
           (han.host:copy-file file copy)
           (check-true (han.host:file-exists-p copy))
           (check-equal
            (han.host:escape-sh-token "a'b")
            "'a'\\''b'")
           (han.host:delete-directory-tree root)
           (check-false (han.host:directory-exists-p root)))
      (ignore-errors
        (when (han.host:directory-exists-p root)
          (han.host:delete-directory-tree root))))))
