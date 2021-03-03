(package-initialize)
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
(setq create-lockfiles nil)
(setq desktop-path '("~/.local/emacs/sessions"))
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
(setq backup-directory-alist
      `((".*" . "~/.local/emacs/backups/")))
(setq auto-save-file-name-transforms
      `((".*" "~/.local/emacs/autosaves/" t)))
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
      "~/.local/emacs/tetris-scores")

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
