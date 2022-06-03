(dolist (var '("EDITOR" "GPG_TTY" "NIX_PATH" "NIX_PROFILES" "NIX_REMOTE" "NIX_SSL_CERT_FILE" "NIX_USER_PROFILE_DIR" "SSH_AUTH_SOCK"))
  (add-to-list 'exec-path-from-shell-variables var))
(exec-path-from-shell-initialize)
