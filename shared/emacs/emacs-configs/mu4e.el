(require 'smtpmail)
(add-to-list 'mu4e-view-actions
             '("ViewInBrowser" . mu4e-action-view-in-browser) t)
(setq
 message-send-mail-function    'smtpmail-send-it
 smtpmail-stream-type          'starttls
 smtpmail-smtp-service         587
 smtpmail-default-smtp-server  "smtp.gmail.com"
 smtpmail-smtp-server          "smtp.gmail.com"
 smtpmail-local-domain         "gmail.com"
 mu4e-sent-messages-behavior   'delete
 mu4e-get-mail-command         "mbsync -a"
 mu4e-maildir "~/.Maildir"
 mu4e-headers-skip-duplicates t
 mu4e-view-show-images t
 mu4e-change-filenames-when-moving t
 mu4e-index-cleanup nil
 mu4e-index-lazy-check t
 mu4e-compose-context-policy 'always-ask)
(add-hook 'mu4e-compose-mode-hook #'(lambda () (auto-save-mode -1)))
(setq
 mu4e-update-interval 300)
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))
(setq message-kill-buffer-on-exit t)
(setq mml-secure-smime-sign-with-sender t)
(setq mm-sign-option 'guided)
(setq mu4e-contexts
      `(,(make-mu4e-context
          :name "BA"
          :enter-func (lambda () (mu4e-message "Entering BA context"))
          :leave-func (lambda () (mu4e-message "Leaving BA context"))
          :match-func (lambda (msg)
                        (and
                         msg
                         (mu4e-message-contact-field-matches
                          msg :to "yurialbuquerque@brickabode.com")
                         (string-prefix-p "/ba" (mu4e-message-field msg :maildir))))
          :vars '((mu4e-trash-folder . "/ba/[Gmail]/Trash")
                  (mu4e-sent-folder . "/ba/[Gmail]/Sent Mail")
                  (mu4e-drafts-folder . "/ba/[Gmail]/Drafts")
                  (mu4e-refile-folder . "/ba/[Gmail]/All Mail")
                  (mu4e-maildir-shortcuts . (("/ba/INBOX"             . ?i)
                                             ("/ba/[Gmail]/Sent Mail" . ?s)
                                             ("/ba/[Gmail]/Trash"     . ?t)
                                             ("/ba/[Gmail]/All Mail"  . ?a)))
                  (mu4e-maildir "~/.Maildir/ba")
                  (user-mail-address . "yurialbuquerque@brickabode.com")
                  (user-full-name . "Yuri Albuquerque")
                  (smtpmail-smtp-user "yurialbuquerque@brickabode.com")
                  (mu4e-compose-signature . "Yuri Albuquerque")))
        ,(make-mu4e-context
          :name "Personal"
          :enter-func (lambda () (mu4e-message "Entering Personal context"))
          :leave-func (lambda () (mu4e-message "Leaving Personal context"))
          :match-func (lambda (msg)
                        (and
                         msg
                         (mu4e-message-contact-field-matches
                          msg :to "yuridenommus@gmail.com")
                         (string-prefix-p "/personal" (mu4e-message-field msg :maildir))))
          :vars '((mu4e-trash-folder . "/personal/[Gmail]/Lixeira")
                  (mu4e-sent-folder . "/personal/[Gmail]/E-mails enviados")
                  (mu4e-drafts-folder . "/personal/[Gmail]/Rascunhos")
                  (mu4e-refile-folder . "/personal/[Gmail]/Todos os e-mails")
                  (mu4e-maildir-shortcuts . (("/personal/INBOX"                    . ?i)
                                             ("/personal/[Gmail]/E-mails enviados" . ?e)
                                             ("/personal/[Gmail]/Lixeira"          . ?l)
                                             ("/personal/[Gmail]/Todos os e-mails" . ?t)))
                  (mu4e-maildir "~/.Maildir/personal")
                  (user-mail-address . "yuridenommus@gmail.com")
                  (user-full-name . "Yuri Albuquerque")
                  (smtpmail-smtp-user "yuridenommus@gmail.com")
                  (mu4e-compose-signature . "Yuri Albuquerque")))))
(use-package helm-mu)
(defun custom-mu4e-read-maildir (prompt maildirs predicate require-match initial-input)
  "Use helm instead of ido. PROMPT MAILDIRS PREDICATE REQUIRE-MATCH INITIAL-INPUT."
  (helm-comp-read prompt maildirs
                  :name prompt
                  :must-match t))
(setq mu4e-completing-read-function #'custom-mu4e-read-maildir)
