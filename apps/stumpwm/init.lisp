;;
;;
(in-package :stumpwm)
(load-module "swm-gaps")
(load "~/.stumpwm.d/mode-line.lisp")
(load "~/.stumpwm.d/ck-apps.lisp")

(set-prefix-key (stumpwm:kbd "C-z"))

;; Make stumpm handle errors better
(setf stumpwm:*top-level-error-action* :break)

;; Start swank on 4004 to interact with stumpwm from slime
;; (require :swank)
;; (swank-loader:init)
;; (swank:create-server
;;  :port 4004
;;  :style swank:*communication-style*
;;  :dont-close t
;; )

(set-module-dir (pathname-as-directory (concat (getenv "HOME") "/.stumpwm.d/stumpwm-contrib")))

;; Themeing
(setf *window-border-style* :none)
(load-module "ttf-fonts")

;; Gaps

;; (setf swm-gaps:*inner-gaps-size* 12)
;; (setf swm-gaps:*outer-gaps-size* 24)

(run-commands "toggle-gaps")
(setf stumpwm:*screen-mode-line-format*
      (list "%w | "
            '(:eval (stumpwm:run-shell-command "date" t))))

;; Keybindings

;; motion
(define-key *root-map* (kbd "h") "move-focus left")
(define-key *root-map* (kbd "q") "fullscreen")
(define-key *root-map* (kbd "l") "move-focus right")
(undefine-key *root-map* (kbd "k"))

(define-key *root-map* (kbd "M-h") "move-window left")
(define-key *root-map* (kbd "M-j") "move-window down")
(define-key *root-map* (kbd "M-k") "move-window up")
(define-key *root-map* (kbd "M-l") "move-window right")
(define-key *root-map* (kbd "M-Down") "move-window down")

(define-key *root-map* (kbd "Up") "move-focus up")
(define-key *root-map* (kbd "Down") "move-focus down")
(define-key *root-map* (kbd "RET") "move-focus down")
(define-key *root-map* (kbd "j") "move-focus down")
(define-key *root-map* (kbd "e") "exec emacsclient-snapshot -c")
(define-key *root-map* (kbd "C-e") "exec emacs-snapshot")
(define-key *root-map* (kbd "c") "exec urxvt")
(define-key *root-map* (kbd "C-c") "exec urxvt")

(define-key *top-map* (kbd "M-g") "grouplist")
; (undefine-key *top-map* (kbd "S-g"))

(run-shell-command "compton")

(setf *message-window-gravity* :center
      *input-window-gravity* :center
      *window-border-style* :tight
      *message-window-padding* 0
      *maxsize-border-width* 4
      *normal-border-width* 8
      *transient-border-width* 8
      stumpwm::*float-window-border* 2
      stumpwm::*float-window-title-height* 2
      *mouse-focus-policy* :click)

(set-fg-color "#000000")
(set-bg-color "#00ff00")
(set-focus-color "#ff4400")
(set-border-color "#00ff00")
(set-msg-border-width 10)

