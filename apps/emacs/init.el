(ido-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-strict-missing-semi-warning nil)
 '(js2-strict-trailing-comma-warning t)
 '(package-selected-packages '(js2-mode ox-reveal frame-tabs)))

;; Get rid of clutter
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'ox-reveal)

(add-to-list 'auto-mode-alist '("\\.sjs\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(require 'package)
(add-to-list 'package-archives
   '("melpa" . "https://melpa.org/packages/") t)

; (add-to-list 'load-path "~/.emacs.d/codeium.el")
; (load "~/.emacs.d/config/codeium.el")

(message "scripts loaded")



