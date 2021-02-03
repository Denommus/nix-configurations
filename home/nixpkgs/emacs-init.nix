{ pkgs }:
let
  emacs-dir = pkgs.stdenv.mkDerivation {
    pname = "emacs-init-subdir";
    version = "0.0";
    src = ./emacs;
    installPhase = ''
    mkdir $out
    cp -r * $out/
    '';
  };
in
{
  enable = true;
  recommendedGcSettings = true;

  prelude = builtins.readFile ./prelude.el;

  usePackage = {
    bbdb = {
      enable = true;
      command = [
        "bbdb-initialize"
      ];
      config = builtins.readFile ./emacs-configs/bbdb.el;
    };

    helm-config = {
      enable = true;
      demand = true;
      after = [ "helm" ];
    };

    helm = {
      enable = true;
      demand = true;
      command = [
        "helm-mode"
      ];
      init = builtins.readFile ./emacs-inits/helm.el;
      bind = {
        "C-c h" = "helm-command-prefix";
        "M-x" = "helm-M-x";
        "C-c y" = "helm-show-kill-ring";
        "C-x C-f" = "helm-find-files";
      };
      bindLocal = {
        helm-map = {
          "<tab>" = "helm-execute-persistent-action";
          "C-i" = "helm-execute-persistent-action";
          "C-z" = "helm-select-action";
        };
      };
      config = builtins.readFile ./emacs-configs/helm.el;
    };

    switch-window = {
      enable = true;
      bind = {
        "C-x o" = "switch-window";
        "C-x 1" = "switch-window-then-maximize";
        "C-x 2" = "switch-window-then-split-below";
        "C-x 3" = "switch-window-then-split-right";
        "C-x 0" = "switch-window-then-delete";
        "C-x 4 d" = "switch-window-then-dired";
        "C-x 4 f" = "switch-window-then-find-file";
        "C-x 4 m" = "switch-window-then-compose-mail";
        "C-x 4 r" = "switch-window-then-find-file-read-only";
        "C-x 4 C-f" = "switch-window-then-find-file";
        "C-x 4 C-o" = "switch-window-then-display-buffer";
        "C-x 4 0" = "switch-window-then-kill-buffer";
      };
    };

    comint = {
      enable = true;
      init = "(savehist-mode 1)";
      config = builtins.readFile ./emacs-configs/comint.el;
    };

    flycheck = {
      enable = true;
      demand = true;
      after = [ "nix-sandbox" ];
      command = [
        "global-flycheck-mode"
      ];
      init = builtins.readFile ./emacs-inits/flycheck.el;
      config = "(global-flycheck-mode 1)";
    };

    nix-sandbox = {
      enable = true;
      demand = true;
      command = [
        "nix-current-sandbox"
        "nix-executable-find"
        "nix-shell-command"
      ];
    };

    nix-buffer = {
      enable = true;
    };

    smartparens = {
      enable = true;
      demand = true;
      after = [ "hydra" ];
      command = [
        "smartparens-mode"
        "smartparens-strict-mode"
      ];
      # Leaving this as a string because it refers to an external derivation
      config = ''
      (defun enable-smartparens-mode ()
        (smartparens-mode +1)
        (smartparens-strict-mode 1))
      (add-hook 'emacs-lisp-mode-hook       #'enable-smartparens-mode)
      (add-hook 'eval-expression-minibuffer-setup-hook #'enable-smartparens-mode)
      (add-hook 'ielm-mode-hook             #'enable-smartparens-mode)
      (add-hook 'lisp-mode-hook             #'enable-smartparens-mode)
      (add-hook 'lisp-interaction-mode-hook #'enable-smartparens-mode)
      (add-hook 'scheme-mode-hook           #'enable-smartparens-mode)
      (add-hook 'clojure-mode-hook          #'enable-smartparens-mode)
      (add-hook 'ruby-mode-hook #'enable-smartparens-mode)
      (add-hook 'slime-repl-mode-hook #'enable-smartparens-mode)
      (load-file "${emacs-dir}/smartparens.el")
      '';
    };

    hydra = {
      enable = true;
    };

    yasnippet = {
      enable = true;
      command = [
        "yas-global-mode"
        "yas-load-directory"
        "yas-minor-mode"
      ];
      # Leaving this as a string because it refers to an external derivation
      config = ''
      (yas-global-mode 1)
      (yas-load-directory "${emacs-dir}/snippets")
      (add-hook 'term-mode-hook #'(lambda () (yas-minor-mode -1)))
      '';
    };

    typescript-mode = {
      enable = true;
      demand = true;
      mode = [
        "\"\\\\.tsx?\\\\'\""
      ];
    };

    web-mode = {
      enable = true;
      mode = [
        "\"\\\\.html?\\\\'\""
        "\"\\\\.phtml\\\\'\""
        "\"\\\\.tpl\\\\.php\\\\'\""
        "\"\\\\.php\\\\'\""
        "\"\\\\.jsp\\\\'\""
        "\"\\\\.as[cp]x\\\\'\""
        "\"\\\\.erb\\\\'\""
        "\"\\\\.mustache\\\\'\""
        "\"\\\\.djhtml\\\\'\""
        "\"\\\\.razor\\\\'\""
      ];
      init = builtins.readFile ./emacs-inits/web-mode.el;
    };

    undo-tree = {
      enable = true;
      demand = true;
      command = [
        "global-undo-tree-mode"
      ];
      config = "(global-undo-tree-mode 1)";
    };

    projectile = {
      enable = true;
      diminish = [ "projectile-mode" ];
      command = [ "projectile-mode" ];
      init = "(require 'tramp)";
      bindKeyMap = {
        "C-z" = "projectile-command-map";
      };
      config = builtins.readFile ./emacs-configs/projectile.el;
    };

    helm-projectile = {
      enable = true;
      demand = true;
      command = [
        "helm-projectile-on"
      ];
      after = [ "projectile" ];
      config = "(helm-projectile-on)";
    };

    magit = {
      enable = true;
      command = [ "magit-custom" ];
      config = builtins.readFile ./emacs-configs/magit.el;
    };

    magit-svn = {
      enable = true;
      after = [ "magit" ];
    };

    forge = {
      enable = true;
      config = builtins.readFile ./emacs-configs/forge.el;
    };

    cmake-mode = {
      enable = true;
    };

    cyberpunk-theme = {
      enable = true;
      init = "(load-theme 'cyberpunk t)";
    };

    org = {
      package = "org-plus-contrib";
      enable = true;
      after = [ "flyspell" ];
      command = [
        "deactivate-c-tab"
      ];
      bind = {
          "C-c l" = "org-store-link";
          "C-c c" = "org-capture";
          "C-c a" = "org-agenda";
          "C-c b" = "org-iswitchb";
      };
      bindLocal = {
        org-mode-map = {
          "C-c h i" = "helm-org-in-buffer-headings";
          "M-n" = "org-move-item-down";
          "M-p" = "org-move-item-up";
          "C-M-n" = "org-move-subtree-down";
          "C-M-p" = "org-move-subtree-up";
        };
      };

      init = builtins.readFile ./emacs-inits/org.el;

      config = builtins.readFile ./emacs-configs/org.el;
    };

    org-bullets = {
      enable = true;
      after = [ "org" ];
      demand = true;
      command = [ "org-bullets-mode" ];
      config = "(add-hook 'org-mode-hook #'org-bullets-mode)";
    };

    org-gcal = {
      enable = true;
      after = [ "org" ];
      command = [
        "org-gcal-fetch"
        "org-gcal-post-at-point"
        "setup-org-gcal"
      ];
      config = builtins.readFile ./emacs-configs/org-gcal.el;
    };

    ox = {
      enable = true;
      after = [ "org" ];
    };

    # ox-taskjuggler = {
    #   enable = true;
    #   after = [ "org" "ox" ];
    #   init = "(add-to-list 'org-export-backends 'taskjuggler)";
    # };

    org-ref = {
      enable = true;
      after = [ "org" ];
      demand = true;
    };

    ox-epub = {
      enable = true;
      after = [ "org" "ox" ];
      init = "(add-to-list 'org-export-backends 'epub)";
    };

    ox-latex = {
      enable = true;
      after = [ "org" "ox" ];
      config = builtins.readFile ./emacs-configs/ox-latex.el;
    };

    dune = {
      enable = true;
      after = [ "smartparens" ];
      hook = [ "(dune-mode . enable-smartparens-mode)" ];
    };

    editorconfig = {
      enable = true;
      command = [
        "editorconfig-mode"
      ];
      config = "(editorconfig-mode 1)";
    };

    helm-flyspell = {
      enable = true;
      after = [ "helm" ];
    };

    flyspell = {
      enable = true;
      after = [ "helm-flyspell" ];
      bindLocal = {
        flyspell-mode-map = {
          "C-;" = "helm-flyspell-correct";
        };
      };
    };

    nix-mode = {
      enable = true;
    };

    nixos-options = {
      enable = true;
    };

    ob-plantuml = {
      enable = true;
    };

    company = {
      enable = true;
      demand = true;
      command = [
        "company-mode"
        "global-company-mode"
      ];
      config = "(global-company-mode 1)";
    };

    company-nixos-options = {
      enable = true;
      after = [ "nixos-options" "company" ];
      init = "(add-to-list 'company-backends 'company-nixos-options)";
    };

    helm-nixos-options = {
      enable = true;
      after = [ "helm" "nixos-options" ];
      bind = {
        "C-c n" = "helm-nixos-options";
      };
    };

    lsp-mode = {
      enable = true;
      command = [
        "lsp"
      ];
      bindLocal = {
        lsp-mode-map = {
              "C-c C-t" = "lsp-describe-thing-at-point";
              "C-c C-r" = "lsp-rename";
              "C-c C-i" = "lsp-describe-thing-at-point";
              "C-c t" = "lsp-describe-thing-at-point";
              "C-c r" = "lsp-rename";
              "C-c i" = "lsp-describe-thing-at-point";
              "M-." = "xref-find-definitions";
        };
      };
      init = "(setq lsp-prefer-flymake nil)";
    };

    lsp-ui = {
      enable = true;
      demand = true;
      command = [
        "lsp-ui-mode"
      ];
      init = builtins.readFile ./emacs-inits/lsp-ui.el;
    };

    reason-mode = {
      enable = true;
      after = [ "lsp-mode" "nix-sandbox" ];
      init = builtins.readFile ./emacs-inits/reason-mode.el;
    };

    tuareg = {
      enable = true;
      after = [ "lsp-mode" "nix-sandbox" "reason-mode" ];
      init = builtins.readFile ./emacs-inits/tuareg.el;
    };

    multiple-cursors = {
      enable = true;
      demand = true;
    };

    eyebrowse = {
      enable = true;
      demand = true;
      command = [
        "eyebrowse-mode"
      ];
      bind = {
        "<C-tab>" = "eyebrowse-next-window-config";
        "<C-iso-lefttab>" = "eyebrowse-prev-window-config";
      };
      init = builtins.readFile ./emacs-inits/eyebrowse.el;
    };

    haskell-mode = {
      enable = true;
      init = "(add-hook 'haskell-mode-hook #'subword-mode)";
    };

    mu4e = {
      enable = true;
      package = epkgs: null;
      command = [ "mu4e" ];
      diminish = [ "mu4e-mode" ];
      after = [ "helm-mu" ];
      config = builtins.readFile ./emacs-configs/mu4e.el;
    };

    helm-mu = {
      enable = true;
    };

    helm-bbdb = {
      enable = true;
      command = [ "helm-bbdb" ];
      after = [ "helm" "bbdb" ];
    };

    yaml-mode = {
      enable = true;
    };

    gherkin-mode = {
      enable = true;
      mode = [
        "\"\\\\.feature\\\\'\""
      ];
    };

    csharp-mode = {
      enable = true;
    };
  };
}
