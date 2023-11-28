;; Set up some keyboard shortcuts

(defun reload-init-file ()
  "Reload emacs init file."
  (interactive)
  (load-file user-init-file)
  (message "Init file reloaded."))

(global-set-key (kbd "C-c r") 'reload-init-file)
