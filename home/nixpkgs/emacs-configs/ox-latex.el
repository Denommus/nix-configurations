(add-to-list 'org-latex-packages-alist '("AUTO" "babel" t) t)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(add-to-list 'org-latex-classes
             '("tccv" "\\documentclass[11pt]{tccv}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(add-to-list 'org-latex-classes
             '("abntex" "\\documentclass[11pt]{abntex2}"
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
(add-to-list 'org-latex-classes
             '("iiufrgs"
               "\\documentclass{iiufrgs}\n\\usepackage[alf,abnt-emphasize=bf]{abntex2cite}\n[DEFAULT-PACKAGES]\n[PACKAGES]\n[EXTRA]\n"
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
(setq org-latex-listings 'minted)
