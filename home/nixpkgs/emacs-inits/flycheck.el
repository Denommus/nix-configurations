(setq sentence-end-double-space nil)
(setq flycheck-command-wrapper-function
      (lambda (cmd) (let ((sandbox (nix-current-sandbox)))
                      (if sandbox
                          (apply 'nix-shell-command sandbox cmd)
                        cmd))))
