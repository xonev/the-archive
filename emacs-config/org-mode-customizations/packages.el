;;; packages.el --- org-mode-customizations layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Steven Oxley <soxley@MacBook-Pro.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `org-mode-customizations-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `org-mode-customizations/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `org-mode-customizations/pre-init-PACKAGE' and/or
;;   `org-mode-customizations/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst org-mode-customizations-packages
  '((org :location built-in)
    dash)
  "The list of Lisp packages required by the org-mode-customizations layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun org-mode-customizations/init-dash ()
  (use-package dash
    :defer t))

(defun org-mode-customizations/post-init-org ()
  (use-package org
    :defer t
    :config
    (progn

      (setq org-directory "/Users/soxley/workspace/the-archive/private/org/")

      (defun org-filename (filename)
        (concat org-directory filename))

      (setq org-agenda-files `(,(org-filename "seeq.org")
                              ,(org-filename "personal.org")
                              ,(org-filename "consulting.org")
                              ,(org-filename "tickler.org")))

      (setq org-capture-templates `(("s" "Seeq Todo [inbox]" entry
                                    (file+headline ,(org-filename "seeq.org") "Inbox")
                                    "* TODO %i%?")
                                    ("p" "Personal Todo [inbox]" entry
                                    (file+headline ,(org-filename "personal.org") "Inbox")
                                    "* TODO %i%?")
                                    ("c" "Client Todo [inbox]" entry
                                    (file+headline ,(org-filename "consulting.org") "Inbox")
                                    "* TODO %i%?")
                                    ("T" "Tickler" entry
                                    (file+headline ,(org-filename "tickler.org") "Tickler")
                                    "* %i%? \n %U")
                                    ("r" "Reference" entry
                                    (file+headline ,(org-filename "reference.org") "Notes")
                                    "* %i%?")))

      (setq org-refile-targets `((,(org-filename "seeq.org") :maxlevel . 3)
                                (,(org-filename "personal.org") :maxlevel . 3)
                                (,(org-filename "consulting.org") :maxlevel . 3)
                                (,(org-filename "someday.org") :level . 1)
                                (,(org-filename "tickler.org") :maxlevel . 2)
                                (,(org-filename "reference.org") :level . 1)))

      (setq org-todo-keywords
            '((sequence "TODO(t)" "DOING(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

      (add-hook 'org-mode-hook 'org-indent-mode)

      (setq org-clock-persist 'history)
      (org-clock-persistence-insinuate))))
;;; packages.el ends here
