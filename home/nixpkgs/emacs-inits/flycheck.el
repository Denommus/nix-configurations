(setq sentence-end-double-space nil)
(setq flycheck-command-wrapper-function
      (lambda (cmd)
        (apply 'nix-shell-command (nix-current-sandbox)
               cmd)))
(setq flycheck-executable-find
      (lambda (executable)
        (nix-executable-find (nix-current-sandbox) executable)))
