(defun setup-org-gcal ()
  (let* ((gcal-plist (car (auth-source-search :host "gcal-ba")))
         (gcal-username (plist-get gcal-plist :user))
         (gcal-secret (funcall (plist-get gcal-plist :secret))))
    (setq org-gcal-client-id gcal-username
          org-gcal-client-secret gcal-secret
          org-gcal-file-alist `(("yurialbuquerque@brickabode.com" . ,(concat org-directory "/brickabode.org"))))
    (org-gcal-fetch)))
(add-hook 'org-agenda-mode-hook #'setup-org-gcal)
(add-hook 'org-capture-after-finalize-hook
          (lambda ()
            (when (equal (plist-get org-capture-plist :key)
                         shared-capture-key)
              (org-gcal-post-at-point))))
