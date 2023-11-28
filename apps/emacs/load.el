(load-file "interface.el")
(load-file "keyboard.el")

;; Package management with melpa
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; File associations
(add-to-list 'auto-mode-alist '("\\.sjs\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(put 'narrow-to-region 'disabled nil)

;; Customizations
(load-file "./my-org.el")

(message "My scripts loaded")



