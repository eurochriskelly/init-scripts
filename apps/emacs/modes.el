;; Ensure paredit mode is on in elisp files bg default
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (if (fboundp 'paredit-mode)
		(paredit-mode 1))))
