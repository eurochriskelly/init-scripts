;; Set up co-pilot
(message "Setting up copilot ...")

;; you can utilize :map :hook and :config to customize copilot
;; (use-package copilot
;;   :quelpa (copilot :fetcher github
;;                    :repo "zerolfx/copilot.el"
;;                    :branch "main"
;;                    :files ("dist" "*.el")))
;; you can utilize :map :hook and :config to customize copilot

(message "Setting up copilot ... 2")
;;(add-hook 'prog-mode-hook 'copilot-mode)
(message "Setting up copilot ... 3")
;;(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
;;(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

(message "Setting up copilot ... 4")

;; Example major mode translation
;; (add-to-list 'copilot-major-mode-alist '("enh-ruby" . "ruby"))

(message "Copilot mode loaded")
