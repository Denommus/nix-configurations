(defun setup-refmt ()
  (make-local-variable 'refmt-command)
  (setq refmt-command
        (nix-executable-find (nix-current-sandbox) "refmt"))
  (add-hook 'before-save-hook 'refmt-before-save))


(add-hook 'reason-mode-hook #'setup-refmt)
