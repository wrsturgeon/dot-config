( setq
  auto-save-default nil
  line-move-visual nil
  make-backup-files nil
  scroll-conservatively 5
  scroll-step 1
  standard-indent 2
)

(setq-default
  c-basic-offset 2
  indent-tabs-mode nil
  show-trailing-whitespace t
  tab-width 2
)

(defalias 'yes-or-no-p 'y-or-n-p)

(line-number-mode)
(column-number-mode)

(transient-mark-mode 1)

(global-hl-line-mode 1)

(require 'evil)
(evil-mode 1)

(require 'ayu-theme)
(load-theme 'ayu t)
