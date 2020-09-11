(setq sentence-end-double-space nil)
(setq flycheck-command-wrapper-function
      (lambda (cmd)
        (apply 'nix-shell-command (nix-current-sandbox)
               (list (mapconcat 'shell-quote-argument cmd " ")))))
