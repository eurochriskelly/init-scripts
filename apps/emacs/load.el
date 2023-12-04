;; Determine the directory of the current script
(message "---------------------")
(message "Loading my scripts ..")
(defvar current-dir (file-name-directory load-file-name))


;; Load other scripts using the determined directory
(load-file (concat current-dir "interface.el"))
(load-file (concat current-dir "keyboard.el"))
(load-file (concat current-dir "copilot.el"))

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
(load-file (concat current-dir "./my-org.el"))

(message "My scripts loaded")
