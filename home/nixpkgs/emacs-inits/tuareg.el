(defun sandboxed-ocaml-lsp ()
  (make-local-variable 'lsp-ocaml-lang-server-command)
  (setq lsp-ocaml-lang-server-command
        (nix-shell-command (nix-current-sandbox) "ocaml-language-server" "--stdio"))
  (lsp))


(mapc (lambda (x) (add-hook x #'sandboxed-ocaml-lsp))
      '(tuareg-mode-hook caml-mode-hook reason-mode-hook))
