(defun nix-sandbox-setup ()
  (make-local-variable 'lsp-rust-rls-server-command)
  (setq lsp-rust-rls-server-command (nix-shell-command (nix-current-sandbox) "rls"))
  (lsp))

(add-hook 'rust-mode-hook #'nix-sandbox-setup)
