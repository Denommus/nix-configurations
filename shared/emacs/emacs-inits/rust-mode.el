(defun rust-submodes ()
  (subword-mode 1)
  (smartparens-mode 1)
  (add-hook 'before-save-hook #'rust-format-buffer 0 t))

(add-hook 'rust-mode-hook #'rust-submodes)
