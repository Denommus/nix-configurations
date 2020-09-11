(setq org-log-done 'time)
(setq org-agenda-include-diary t)
(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file (concat org-directory "/agenda.org"))
(setq org-export-with-toc nil)
(setq org-confirm-babel-evaluate nil)
(setq org-capture-templates
      `(("j" "Journal" entry (file+datetree ,(concat org-directory "/diario.org"))
         "* %?\nEntrada dia %U\n %i\n")
        ("t" "Task" entry (file+headline ,(concat org-directory "/agenda.org") "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("n" "Note" entry (file+headline ,(concat org-directory "/agenda.org") "Notes")
         "* %?\n  %i\n  %a")))
;; Use minted
(setq org-latex-listings 'minted)
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; Sample minted options.
(setq org-latex-minted-options '(("frame" "lines")
                                 ("fontsize" "\\scriptsize")
                                 ("xleftmargin" "\\parindent")
                                 ("linenos" "")))
