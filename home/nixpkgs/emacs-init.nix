{ pkgs }:
let
  emacs-dir = pkgs.stdenv.mkDerivation {
    pname = "emacs-init-subdir";
    version = "0.0";
    src = ./emacs;
    installPhase = ''
    mkdir $out
    cp -r * $out/
    '';
  };
in
{
  enable = true;
  recommendedGcSettings = true;

  prelude = ''
  (custom-set-variables
   '(inhibit-startup-screen t))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:height 110 :family "Anonymous Pro"))))
   '(font-lock-comment-face ((t (:foreground "#B7B7B7")))))
  (setq history-delete-duplicates t)
  (setq use-package-always-ensure t)
  (setq desktop-path '("~/.emacs.d/sessions"))
  (put 'downcase-region 'disabled nil)
  (put 'narrow-to-region 'disabled nil)
  (put 'dired-find-alternate-file 'disabled nil)
  (setq max-specpdl-size 2000) ;; Some emails break with the default value
  (defun visit-emacs-config ()
    "Visits the user's Emacs' configuration."
    (interactive)
    (find-file user-init-file))
  (global-set-key (kbd "C-c e") #'visit-emacs-config)
  (require 'esh-module)
  (add-to-list 'eshell-modules-list 'eshell-tramp)
  (require 'cl-lib)
  (setq visible-bell 1)
  (add-to-list 'load-path "~/.emacs.d/plugins")
  (add-to-list 'load-path "~/.emacs.d/plugins/erc-sasl")
  (add-to-list 'load-path "~/.emacs.d/plugins/ob-javascript")
  (setq backup-directory-alist
        `((".*" . ,(concat user-emacs-directory "backups/"))))
  (setq auto-save-file-name-transforms
        `((".*" ,(concat user-emacs-directory "autosaves/") t)))
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (scroll-bar-mode 0)
  (column-number-mode 1)
  (add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook #'eldoc-mode)
  (add-hook 'ielm-mode-hook #'eldoc-mode)
  (setq delete-by-moving-to-trash t)
  (global-auto-revert-mode 1)
  (add-hook 'after-change-major-mode-hook #'(lambda ()
                                              (setq indicate-buffer-boundaries t)))
  (global-set-key (kbd "C-s-b") 'windmove-left)
  (global-set-key (kbd "C-s-f") 'windmove-right)
  (global-set-key (kbd "C-s-p") 'windmove-up)
  (global-set-key (kbd "C-s-n") 'windmove-down)
  (setq-default indent-tabs-mode nil)
  (add-to-list 'auto-mode-alist '("PKGBUILD" . pkgbuild-mode))
  (put 'upcase-region 'disabled nil)
  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)

  (global-set-key (kbd "C-s") 'isearch-forward-regexp)
  (global-set-key (kbd "C-r") 'isearch-backward-regexp)
  (global-set-key (kbd "C-M-s") 'isearch-forward)
  (global-set-key (kbd "C-M-r") 'isearch-backward)
  (electric-indent-mode 0)

  (show-paren-mode 1)
  (setq select-enable-clipboard t
        select-enable-primary t
        save-interprogram-paste-before-kill t
        mouse-yank-at-point t)

  (defun convert-to-underscore ()
    "Convert the region from camelCase to underscore. Does nothing if no region is set."
    (interactive)
    (when (region-active-p)
      (let ((case-fold-search nil)
            (begin (region-beginning))
            (end (region-end)))
        (goto-char begin)
        (while (re-search-forward "[A-Z]" end t)
          (replace-match (concat "_" (downcase (match-string 0))) t)
          (goto-char begin)))
      (deactivate-mark)))

  (global-set-key (kbd "C-x C-c")
                  (lambda ()
                    (interactive)
                    (when (yes-or-no-p "Are you really sure?")
                      (call-interactively #'save-buffers-kill-emacs))))

  (defun empty-trash (decision)
    "Empty the trash. DECISION confirms whether that's what you want."
    (interactive (list (yes-or-no-p "Really empty the trash? ")))
    (if decision
        (let ((delete-by-moving-to-trash nil))
          (cl-loop for directory in '("~/.local/share/Trash/files/"
                                      "~/.local/share/Trash/info/")
                   do (cl-loop for file in (directory-files directory)
                               with fullpath = (concat directory file)
                               unless (or (string= file ".") (string= file ".."))
                               do (if (file-directory-p fullpath)
                                      (delete-directory fullpath t)
                                    (delete-file fullpath)))))))

  ;;;;;;;;;;;;;;;;;;;;
  ;; set up unicode
  (when (eq system-type 'windows-nt)
    (prefer-coding-system       'utf-8)
    (set-default-coding-systems 'utf-8)
    (set-terminal-coding-system 'utf-8)
    (set-keyboard-coding-system 'utf-8)
    (setq default-file-name-coding-system 'cp1252)
    ;; From Emacs wiki
    (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
    ;; MS Windows clipboard is UTF-16LE
    (set-clipboard-coding-system 'utf-16le-dos))

  ;;Clean up
  (defun cleanup-buffer-safe ()
    "Set encoding, remove trailing whitespace, replace tab by spaces."
    (interactive)
    (delete-trailing-whitespace)
    (set-buffer-file-coding-system 'utf-8)
    (untabify (point-min) (point-max)))
  (defun cleanup-buffer ()
    "As `cleanup-buffer-safe', but also indent the buffer."
    (interactive)
    (cleanup-buffer-safe)
    (indent-region (point-min) (point-max)))
  (global-set-key (kbd "C-c s") 'cleanup-buffer)

  (global-unset-key (kbd "C-z"))
  (setq tetris-score-file
        "~/.emacs.d/tetris-scores")

  (setq diary-file "~/Dropbox/diary.gpg")
  (setq calendar-latitude -27.594870
        calendar-longitude -48.548219
        calendar-location-name "Florianópolis, Brazil")
  (setq calendar-and-diary-frame-parameters
        '((name . "Calendar") (title . "Calendar")
          (height . 20) (width . 78)
          (minibuffer . t)))
  (setq calendar-date-style "european")

  (c-add-style "qt" '("stroustrup" (indent-tabs-mode . nil) (tab-width . 4)))
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
  (add-hook 'c-mode-common-hook
            #'(lambda ()
                (c-set-style "qt")
                (subword-mode 1)))

  (winner-mode 1)
  (global-set-key (kbd "C-c f") #'winner-redo)
  (global-set-key (kbd "C-c b") #'winner-undo)
  '';

  usePackage = {
    bbdb = {
      enable = true;
      command = [
        "bbdb-initialize"
      ];
      config = ''
      (bbdb-initialize 'message 'mu4e 'pgp 'anniv)
      (setq bbdb-file "~/Dropbox/bbdb.gpg")
      (setq bbdb-complete-name-full-completion t)
      (setq bbdb-completion-type 'primary-or-name)
      (setq bbdb-complete-name-allow-cycling t)
      (setq bbdb-mail-user-agent 'mu4e-user-agent)
      (setq mu4e-view-mode-hook 'bbdb-mua-auto-update)
      (setq mu4e-compose-complete-addresses nil)
      (setq bbdb-mua-pop-up t)
      (setq bbdb-mua-pop-up-window-size 5)
      (setq mu4e-view-show-addresses t)
      '';
    };

    helm-config = {
      enable = true;
      demand = true;
      after = [ "helm" ];
    };

    helm = {
      enable = true;
      demand = true;
      command = [
        "helm-mode"
      ];
      init = ''
      (setq helm-display-function 'helm-display-buffer-in-own-frame
            helm-display-buffer-reuse-frame t
            helm-use-undecorated-frame-option t)
      '';
      bind = {
        "C-c h" = "helm-command-prefix";
        "M-x" = "helm-M-x";
        "C-c y" = "helm-show-kill-ring";
        "C-x C-f" = "helm-find-files";
      };
      bindLocal = {
        helm-map = {
          "<tab>" = "helm-execute-persistent-action";
          "C-i" = "helm-execute-persistent-action";
          "C-z" = "helm-select-action";
        };
      };
      config = ''
      (helm-mode 1)
      (add-hook 'eshell-mode-hook
                #'(lambda ()
                    (eshell-cmpl-initialize)
                    (define-key eshell-mode-map [remap eshell-pcomplete] 'helm-esh-pcomplete)
                    (define-key eshell-mode-map (kbd "M-p") 'helm-eshell-history)
                    (company-mode -1)))
      '';
    };

    switch-window = {
      enable = true;
      bind = {
        "C-x o" = "switch-window";
        "C-x 1" = "switch-window-then-maximize";
        "C-x 2" = "switch-window-then-split-below";
        "C-x 3" = "switch-window-then-split-right";
        "C-x 0" = "switch-window-then-delete";
        "C-x 4 d" = "switch-window-then-dired";
        "C-x 4 f" = "switch-window-then-find-file";
        "C-x 4 m" = "switch-window-then-compose-mail";
        "C-x 4 r" = "switch-window-then-find-file-read-only";
        "C-x 4 C-f" = "switch-window-then-find-file";
        "C-x 4 C-o" = "switch-window-then-display-buffer";
        "C-x 4 0" = "switch-window-then-kill-buffer";
      };
    };

    comint = {
      enable = true;
      init = "(savehist-mode 1)";
      config = ''
      (setq comint-password-prompt-regexp
              (concat comint-password-prompt-regexp
                      "\\|^\\[sudo\\]"))
      '';
    };

    flycheck = {
      enable = true;
      after = [ "nix-sandbox" ];
      command = [
        "global-flycheck-mode"
      ];
      init = ''
      (setq sentence-end-double-space nil)
      (setq flycheck-command-wrapper-function
          (lambda (cmd) (let ((sandbox (nix-current-sandbox)))
                          (if sandbox
                            (apply 'nix-shell-command sandbox cmd)
                            cmd))))
      (global-flycheck-mode)
      '';
    };

    nix-sandbox = {
      enable = true;
      command = [
        "nix-current-sandbox"
      ];
    };

    nix-buffer = {
      enable = true;
    };

    smartparens = {
      enable = true;
      after = [ "hydra" ];
      command = [
        "smartparens-mode"
        "smartparens-strict-mode"
      ];
      config = ''
      (defun enable-smartparens-mode ()
        (smartparens-mode +1)
        (smartparens-strict-mode 1))
      (add-hook 'emacs-lisp-mode-hook       #'enable-smartparens-mode)
      (add-hook 'eval-expression-minibuffer-setup-hook #'enable-smartparens-mode)
      (add-hook 'ielm-mode-hook             #'enable-smartparens-mode)
      (add-hook 'lisp-mode-hook             #'enable-smartparens-mode)
      (add-hook 'lisp-interaction-mode-hook #'enable-smartparens-mode)
      (add-hook 'scheme-mode-hook           #'enable-smartparens-mode)
      (add-hook 'clojure-mode-hook          #'enable-smartparens-mode)
      (add-hook 'ruby-mode-hook #'enable-smartparens-mode)
      (add-hook 'slime-repl-mode-hook #'enable-smartparens-mode)
      (load-file "${emacs-dir}/smartparens.el")
      '';
    };

    hydra = {
      enable = true;
    };

    yasnippet = {
      enable = true;
      command = [
        "yas-global-mode"
        "yas-load-directory"
        "yas-minor-mode"
      ];
      config = ''
      (yas-global-mode 1)
      (yas-load-directory "${emacs-dir}/snippets")
      (add-hook 'term-mode-hook #'(lambda () (yas-minor-mode -1)))
      '';
    };

    web-mode = {
      enable = true;
      mode = [
        "\\.html?\\'"
        "\\.phtml\\'"
        "\\.tpl\\.php\\'"
        "\\.php\\'"
        "\\.jsp\\'"
        "\\.as[cp]x\\'"
        "\\.erb\\'"
        "\\.mustache\\'"
        "\\.djhtml\\'"
        "\\.razor\\'"
      ];
      init = ''
      (setq web-mode-enable-engine-detection t)
      (setq web-mode-markup-indent-offset 4)
      '';
    };

    undo-tree = {
      enable = true;
      demand = true;
      command = [
        "global-undo-tree-mode"
      ];
      config = "(global-undo-tree-mode 1)";
    };

    projectile = {
      enable = true;
      diminish = [ "projectile-mode" ];
      command = [ "projectile-mode" ];
      init = "(require 'tramp)";
      bindKeyMap = {
        "C-z" = "projectile-command-map";
      };
      config = ''
      (projectile-mode)
      (setq projectile-indexing-method 'alien)
      (setq projectile-mode-line "Projectile") ;; Projectile makes tramp A LOT slower becauseof the mode line
      '';
    };

    helm-projectile = {
      enable = true;
      demand = true;
      command = [
        "helm-projectile-on"
      ];
      after = [ "projectile" ];
      config = "(helm-projectile-on)";
    };

    magit = {
      enable = true;
      command = [ "magit-custom" ];
      config = ''
      (defun magit-custom ()
        (local-unset-key (kbd "<C-tab>")))
      (add-hook 'magit-mode-hook #'magit-custom)
      '';
    };

    magit-svn = {
      enable = true;
      after = [ "magit" ];
    };

    forge = {
      enable = true;
      config = ''
      (add-to-list 'forge-alist '("git.brickabode.com" "git.brickabode.com/api/v4" "git.brickabode.com" forge-gitlab-repository))
      '';
    };

    cmake-mode = {
      enable = true;
      mode = [
        "CMakeLists.txt"
      ];
    };

    cyberpunk-theme = {
      enable = true;
      init = "(load-theme 'cyberpunk t)";
    };

    org = {
      enable = true;
      after = [ "flyspell" ];
      command = [
        "deactivate-c-tab"
      ];
      bind = {
          "C-c l" = "org-store-link";
          "C-c c" = "org-capture";
          "C-c a" = "org-agenda";
          "C-c b" = "org-iswitchb";
      };
      bindLocal = {
        org-mode-map = {
          "C-c h i" = "helm-org-in-buffer-headings";
          "M-n" = "org-move-item-down";
          "M-p" = "org-move-item-up";
          "C-M-n" = "org-move-subtree-down";
          "C-M-p" = "org-move-subtree-up";
        };
      };

      init = ''
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
      '';

      config = ''
      (add-to-list 'org-latex-packages-alist '("" "minted"))
      (add-to-list 'org-export-backends 'md)
      (require 'org-bibtex)
      (defun deactivate-c-tab ()
        "Deactivate a key in `org-mode'."
        (local-unset-key (kbd "<C-tab>")))
      (add-hook 'org-mode-hook #'deactivate-c-tab)
      (add-hook 'org-mode-hook #'auto-fill-mode)
      (add-hook 'org-mode-hook #'(lambda () (flyspell-mode 1)))
      (require 'org-mu4e)
      (require 'org-ref)
      (require 'org-tempo)
      ;; FIXME: 
      (org-babel-do-load-languages
           'org-babel-load-languages
           '((dot . t)
             (emacs-lisp . t)
             (haskell . t)
             (lisp . t)
             (ocaml . t)
             (makefile . t)
             (calc . t)
             (gnuplot . t)
             (ditaa . t)
             (js . t)
             (javascript . t)
             (org . t)
             (ruby . t)
             (sql . t)
             (sqlite . t)
             (python . t)
             (rust . t)
             (plantuml . t)))
      '';
    };

    org-plus-contrib = {
      enable = true;
      after = [ "org" ];
    };

    org-bullets = {
      enable = true;
      after = [ "org" ];
      command = [ "org-bullets-mode" ];
      config = "(add-hook 'org-mode-hook #'org-bullets-mode)";
    };

    org-gcal = {
      enable = true;
      after = [ "org" ];
      command = [
        "org-gcal-fetch"
        "org-gcal-post-at-point"
        "setup-org-gcal"
      ];
      config = ''
      (defun setup-org-gcal ()
        (let* ((gcal-plist (car (auth-source-search :host "gcal-ba")))
               (gcal-username (plist-get gcal-plist :user))
               (gcal-secret (funcall (plist-get gcal-plist :secret))))
          (setq org-gcal-client-id gcal-username
                org-gcal-client-secret gcal-secret
                org-gcal-file-alist `(("yurialbuquerque@brickabode.com" . ,(concat org-directory "/brickabode.org"))))
          (org-gcal-fetch)))
      (add-hook 'org-agenda-mode-hook #'setup-org-gcal)
      (add-hook 'org-capture-after-finalize-hook
              (lambda ()
                (when (equal (plist-get org-capture-plist :key)
                             shared-capture-key)
                  (org-gcal-post-at-point))))
      '';
    };

    ox = {
      enable = true;
      after = [ "org" ];
    };

    ox-taskjuggler = {
      enable = true;
      after = [ "org" "ox" ];
      init = "(add-to-list 'org-export-backends 'taskjuggler)";
    };

    ox-epub = {
      enable = true;
      after = [ "org" "ox" ];
      init = "(add-to-list 'org-export-backends 'epub)";
    };

    ox-latex = {
      enable = true;
      after = [ "org" "ox" ];
      config = ''
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
      '';
    };

    dune = {
      enable = true;
      after = [ "smartparens" ];
      hook = [ "(dune-mode . enable-smartparens-mode)" ];
    };

    editorconfig = {
      enable = true;
      command = [
        "editorconfig-mode"
      ];
      config = "(editorconfig-mode 1)";
    };

    helm-flyspell = {
      enable = true;
      after = [ "helm" ];
    };

    flyspell = {
      enable = true;
      after = [ "helm-flyspell" ];
      bindLocal = {
        flyspell-mode-map = {
          "C-;" = "helm-flyspell-correct";
        };
      };
    };

    nix-mode = {
      enable = true;
      mode = [
        "\\.nix\\'"
      ];
    };

    nixos-options = {
      enable = true;
    };

    company = {
      enable = true;
      demand = true;
      command = [
        "company-mode"
        "global-company-mode"
      ];
      config = "(global-company-mode 1)";
    };

    company-nixos-options = {
      enable = true;
      after = [ "nixos-options" "company" ];
      init = "(add-to-list 'company-backends 'company-nixos-options)";
    };

    helm-nixos-options = {
      enable = true;
      after = [ "helm" "nixos-options" ];
      bind = {
        "C-c n" = "helm-nixos-options";
      };
    };
  };
}
