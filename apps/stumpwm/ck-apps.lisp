(defun my/kbd (keys)
  "Prepares KEYS for function `stumpwm:kbd'.
If a character declared in the car of a member of the variable char,
it is replaced with its cdr. This allows the user to input characters
such as « or » and have them replaced with their actual name when
`stumpwm:kbd' is called."
  (kbd (let ((chars '(("«" . "guillemotleft") ("»" . "guillemotright"))))
           (dolist (row chars keys)
             (setf keys (cl-ppcre:regex-replace-all (car row) keys (cdr row)))))))

(defvar *ck-keymap*
  (let ((m (make-sparse-keymap)))
    (define-key m (my/kbd "g") "exec chromium http://gmail.google.com")
    (define-key m (my/kbd "m") "exec urxvt ssh $MACVM")
    m))

(define-key *root-map* (my/kbd "q") '*ck-keymap*)
