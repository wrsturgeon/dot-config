; unfuck backups
(make-directory "~/.emacs_backups/" t)
(make-directory "~/.emacs_autosave/" t)

; Name-value settings
(setq
  auto-save-default nil
  auto-save-file-name-transforms '((".*" "~/.emacs_autosave/" t))
  backup-directory-alist '(("." . "~/.emacs_backups/"))
  frame-inhibit-implied-resize t
  line-move-visual nil
  make-backup-files nil
  pixel-scroll-precision-mode t
  require-final-newline t
  scroll-conservatively 5
  scroll-step 1
  sentence-end-double-space nil
  standard-indent 2
  straight-repository-branch "develop"
  straight-use-package-by-default t
)

; That also, but different, for reasons I don't yet understand
(setq-default
  c-basic-offset 2
  indent-tabs-mode nil
  show-trailing-whitespace t
  tab-width 2
)

; Unbelievably ugly scrollbar & menu bar
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

; don't blink at me
(blink-cursor-mode 0)

; Use [y/n] instead of [yes/no]
(defalias 'yes-or-no-p 'y-or-n-p)

; Show line numbers
(line-number-mode)
(column-number-mode)

;%%%%%%%%%%%%%%%% Packages

; straight.el bootstrap
; verbatim from <https://github.com/radian-software/straight.el?tab=readme-ov-file#getting-started>:
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

; use-package, cannibalized by straight.el
(straight-use-package 'use-package)

; `vi` keymap
(straight-use-package 'evil)
(evil-mode 1)

; line cursor on insert
(straight-use-package 'evil-terminal-cursor-changer)
(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)
  (evil-terminal-cursor-changer-activate))

; Nix mode
(use-package nix-mode
  :mode "\\.nix\\'")

; ayu theme
(use-package ayu-theme
  :config (load-theme 'ayu-dark t))
