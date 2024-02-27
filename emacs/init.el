; Name-value settings
(setq
  auto-save-default nil
  line-move-visual nil
  make-backup-files nil
  scroll-conservatively 5
  scroll-step 1
  standard-indent 2
  ; straight-repository-branch "develop"
)

; That also, but different, for reasons I don't yet understand
(setq-default
  c-basic-offset 2
  indent-tabs-mode nil
  show-trailing-whitespace t
  tab-width 2
)

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

; `vi` keymap
(straight-use-package 'evil)
(require 'evil)
(evil-mode 1)

; line cursor on insert
(straight-use-package 'evil-terminal-cursor-changer)
(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)
  (evil-terminal-cursor-changer-activate))

; Nix mode
(straight-use-package 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
