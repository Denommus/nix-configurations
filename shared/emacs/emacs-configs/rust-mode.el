(defun rust-submodes ()
    (subword-mode 1)
    (smartparens-mode 1))

(add-hook 'rust-mode-hook #'rust-submodes)
