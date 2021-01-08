;; Enable org-mode
(require 'org)

;; turn off auto-fill for org-mode
(add-hook 'org-mode-hook 'turn-off-auto-fill)

;; Make org-mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen


(define-key global-map "\C-ca" 'org-agenda)
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
(add-hook 'org-mode-hook 'org-indent-mode)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (dot . t)
   (clojure . t)
   (js . t)
   (python . t)))

;; Enable graphviz-dot-mode in org-mode source blocks
(add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))

;; Set up GTD agenda files and GTD settings (see here:
;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html)
(define-key global-map "\C-cc" 'org-capture)

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

;; Allow sorting by priority and by current status
(require 'cl-lib)
(require 'dash)

(defun my/todo-text (todo)
  (if (string= todo "|")
      todo
      (save-match-data
          (string-match "\\([[:alpha:]]+\\)" todo)
          (match-string 1 todo))))

(defun my/ordered-todo-keywords ()
  (let* ((keywords (remove-if-not (lambda (x) x) (mapcar #'my/todo-text (rest (first org-todo-keywords)))))
         (not-bar (lambda (elt) (not (string= elt "|"))))
         (unfinished
          (reverse (seq-take-while not-bar keywords)))
         (other-todos
          (cdr (seq-drop-while not-bar keywords))))
    (seq-concatenate 'list unfinished other-todos)))

(my/ordered-todo-keywords)

(defun my/todo-to-int (todo)
  (cl-position-if (lambda (x) (string= x todo)) (my/ordered-todo-keywords)))

(defun my/done-int (todo)
    (cond
     ((string= todo "DONE") 2)
     ((string= todo "CANCELLED") 2)
     (t 1)))

(defun my/org-sort-key ()
  (let* ((todo-max (- (apply #'max (mapcar #'length org-todo-keywords)) 2))
         (_ (message "todo-max: %s" todo-max))
         (todo (my/todo-text (org-entry-get (point) "TODO")))
         (_ (message "todo: %s" todo))
         (my/done-int (if todo (my/done-int todo) todo-max))
         (_ (message "my/done-int: %s" my/done-int))
         (todo-int (if todo (my/todo-to-int todo) todo-max))
         (_ (message "todo-int: %s" todo-int))
         (priority (org-entry-get (point) "PRIORITY"))
         (_ (message "priority: %s" priority))
         (priority-int (if priority (string-to-char priority) org-default-priority))
         (_ (message "priority-int: %s" priority-int)))
    (message "done #:%s priority-int #:%s todo #:%s" my/done-int priority-int todo-int)
    (format "%03d %03d %03d" my/done-int priority-int todo-int)
    ))

(defun my/org-sort-entries ()
  (interactive)
  (org-sort-entries nil ?f #'my/org-sort-key))
