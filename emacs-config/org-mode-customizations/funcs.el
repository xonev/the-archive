(when (and (configuration-layer/package-usedp 'org) (configuration-layer/package-usedp 'dash))

  (defun my/todo-text (todo)
    (if (string= todo "|")
        todo
        (save-match-data
            (string-match "\\([[:alpha:]]+\\)" todo)
            (match-string 1 todo))))

  (defun my/ordered-todo-keywords ()
    (let* ((keywords (cl-remove-if-not (lambda (x) x) (mapcar #'my/todo-text (cl-rest (cl-first org-todo-keywords)))))
          (not-bar (lambda (elt) (not (string= elt "|"))))
          (unfinished
            (reverse (seq-take-while not-bar keywords)))
          (other-todos
            (cdr (seq-drop-while not-bar keywords))))
      (seq-concatenate 'list unfinished other-todos)))

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
    (org-sort-entries nil ?f #'my/org-sort-key)))
