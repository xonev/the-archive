;; -*- mode: elisp -*-
;; ____________________________________________________________________________
;; Aquamacs custom-file warning:
;; Warning: After loading this .emacs file, Aquamacs will also load
;; customizations from `custom-file' (customizations.el). Any settings there
;; will override those made here.
;; Consider moving your startup settings to the Preferences.el file, which
;; is loaded after `custom-file':
;; ~/Library/Preferences/Aquamacs Emacs/Preferences
;; _____________________________________________________________________________

;; Disable the splash screen (to enable it again, replace t with 0)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq inhibit-splash-screen t)

;; PATH
(setenv "PATH" (concat "/usr/local/bin" path-separator (getenv "PATH")))

;; Enable transient mark mode
(transient-mark-mode t)

(add-to-list 'load-path "~/.emacs.d/custom-config/")
(load "javascript-config")
(load "org-mode-config")

;; gfm-mode configuration
(autoload 'gfm-mode "gfm-mode" "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; clojure-mode configuration
(add-hook 'clojure-mode-hook #'subword-mode)
(add-hook 'clojure-mode-hook #'smartparens-strict-mode)
(add-hook 'clojure-mode-hook #'aggressive-indent-mode)

;; use company for autocomplete http://company-mode.github.io/
(add-hook 'after-init-hook 'global-company-mode)
(setq company-dabbrev-downcase nil)
;; set up python company backend
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

;; helm shortcuts
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x g") 'helm-git-grep)

;; fiplr configuration https://github.com/grizzl/fiplr
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(setq fiplr-ignored-globs '((directories (".git" ".svn" "node_modules" "vendor"))
                            (files ("*.jpg" "*.png" "*.zip" "*~"))))

;; tabs configuration
(setq-default indent-tabs-mode nil)

;; smartparens configuration
(require 'smartparens-config)
(global-set-key (kbd "C-c s") 'sp-forward-slurp-sexp)
(global-set-key (kbd "C-c b") 'sp-forward-barf-sexp)
(global-set-key (kbd "C-c M-s") 'sp-backward-slurp-sexp)
(global-set-key (kbd "C-c M-b") 'sp-backward-barf-sexp)

;; delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; evil-mode
(setq evil-want-C-u-scroll t)
(require 'evil)
(evil-mode t)

