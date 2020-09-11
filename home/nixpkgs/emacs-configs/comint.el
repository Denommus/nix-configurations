(setq comint-password-prompt-regexp
      (concat comint-password-prompt-regexp
              "\\|^\\[sudo\\]"))
