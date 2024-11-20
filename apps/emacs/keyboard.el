;; Set up some keyboard shortcuts

(defun reload-init-file ()
  "Reload emacs init file."
  (interactive)
  (load-file user-init-file)
  (message "Init file reloaded."))

(global-set-key (kbd "C-c r") 'reload-init-file)
(global-set-key (kbd "C-h C-k") 'beginning-of-buffer)
(global-set-key (kbd "C-h C-j") 'end-of-buffer)
