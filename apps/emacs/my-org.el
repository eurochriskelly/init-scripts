;; my-org.el
(require 'org)
;; Set up the default key-bindings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-switchb)

(message "set keywords")
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "PROGRESS(p)" "DONE(d)" "CANCELLED(c)")))

(message "Setup agenda commands")
(setq org-agenda-custom-commands
      '(("o n" "Next and Progress Tasks" todo "NEXT|PROGRESS")
	("o p" "Progress Tasks" todo "PROGRESS")))

;; Binding C-c o n to the custom agenda view
(global-set-key (kbd "C-c o n") (lambda () (interactive) (org-agenda nil "o n")))



(message "Set org agenda files")
(setq org-agenda-files
      (append
       '("~/Workspace/repos/my-org/main.org")
       (directory-files-recursively "~/Workspace/repos/my-org/projects/work/" "\\.org$")
       (directory-files-recursively "~/Workspace/repos/my-org/projects/personal/" "\\.org$")))

(global-set-key (kbd "C-c o m")
		(lambda () (interactive) (find-file "~/Workspace/repos/my-org/main.org")))

(message "my-org.el loaded")

