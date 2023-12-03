;; my-org.el
(require 'org)

;; Custom skip function to handle future scheduled tasks
(defun my-skip-unless-ready ()
  "Skip entries that are not ready to be shown."
  (let* ((scheduled-time (org-get-scheduled-time (point)))
	 (scheduled-day (and scheduled-time (time-to-days scheduled-time)))
	 (current-day (time-to-days (current-time)))
	 (subtree-end (save-excursion (org-end-of-subtree t))))
    (if (or (not scheduled-day)  ;; If there's no scheduled day, don't skip
	    (<= scheduled-day current-day))
	nil  ;; Do not skip this entry
      subtree-end)
    ))

;; Set up the default key-bindings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-switchb)

(message "set keywords")
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "PROGRESS(p)" "DONE(d)" "CANCELLED(c)" "DELEGATED(l)")))

(message "Setup agenda commands")
(setq org-agenda-custom-commands
      '(("o n" "Next and Progress Tasks"
	 todo "NEXT|PROGRESS"
	 ((org-agenda-skip-function 'my-skip-unless-ready)))
	("o p" "Progress Tasks"
	 todo "PROGRESS")
	("o t" "Todo without future tasks"
	 todo "TODO"
	 ((org-agenda-skip-function 'my-skip-unless-ready)))))

;; Binding C-c o n to the custom agenda view
(global-set-key (kbd "C-c o n") (lambda () (interactive) (org-agenda nil "o n")))

;; Binding C-c o t for Todo items without future tasks
(global-set-key (kbd "C-c o t") (lambda () (interactive) (org-agenda nil "o t")))

(message "Set org agenda files")
(setq org-agenda-files
      (append
       '("~/Workspace/repos/my-org/main.org")
       (directory-files-recursively "~/Workspace/repos/my-org/projects/work/" "\\.org$")
       (directory-files-recursively "~/Workspace/repos/my-org/projects/personal/" "\\.org$")))

(global-set-key (kbd "C-c o m")
		(lambda () (interactive) (find-file "~/Workspace/repos/my-org/main.org")))

(message "my-org.el loaded")

