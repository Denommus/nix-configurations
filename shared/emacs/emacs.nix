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

    helm = {
      enable = true;
      demand = true;
      command = [
        "helm-mode"
      ];
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
      command = [
        "global-flycheck-mode"
      ];
      init = builtins.readFile ./emacs-inits/flycheck.el;
      config = "(global-flycheck-mode 1)";
    };

    flycheck-projectile = {
      enable = true;
      after = [ "flycheck" "projectile" ];
    };

    direnv = {
      enable = true;
      config = "(direnv-mode)";
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
      defer = true;
      mode = [
        "\"\\\\.tsx?\\\\'\""
      ];
    };

    javascript-mode = {
      enable = true;
      defer = true;
      init = "(setq js-indent-level 2)";
    };

    web-mode = {
      enable = true;
      defer = true;
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
        "\"\\\\.vue\\\\'\""
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
      demand = true;
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
      command = [ "magit-svn-mode" ];
      after = [ "magit" ];
    };

    forge = {
      enable = true;
      config = builtins.readFile ./emacs-configs/forge.el;
    };

    cmake-mode = {
      enable = true;
      defer = true;
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
      command = [ "org-bullets-mode" ];
      config = "(add-hook 'org-mode-hook #'org-bullets-mode)";
    };

    ox = {
      enable = true;
      after = [ "org" ];
    };

    org-ref = {
      enable = true;
      after = [ "org" ];
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
      defer = true;
      after = [ "smartparens" ];
      hook = [ "(dune-mode . enable-smartparens-mode)" ];
    };

    editorconfig = {
      enable = true;
      command = [
        "editorconfig-mode"
      ];
      init = "(editorconfig-mode 1)";
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
      demand = true;
    };

    nixos-options = {
      enable = true;
    };

    ob-plantuml = {
      enable = true;
    };

    plantuml-mode = {
      enable = true;
      defer = true;
      init = ''
      (setq plantuml-jar-path "${pkgs.plantuml}/lib/plantuml.jar")
      (setq plantuml-executable-path "${pkgs.plantuml}/bin/plantuml")
      (setq plantuml-exec-mode 'executable)
      '';
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
      init = builtins.readFile ./emacs-inits/lsp.el;
    };

    eglot = {
      enable = true;
      bindLocal = {
        eglot-mode-map = {
          "C-c C-t" = "eglot-find-typeDefinition";
          "C-c C-r" = "eglot-rename";
          "C-c C-i" = "eglot-find-typeDefinition";
          "C-c t" = "eglot-find-typeDefinition";
          "C-c r" = "eglot-rename";
          "C-c i" = "eglot-find-typeDefinition";
          "M-." "xref-find-definitions";
          "C-." "xref-find-references";
        };
      };

      custom = ''
        (eglot-autoshutdown t)
        (eglot-extend-to-xref t)
        (eglot-send-changes-idle-time 2.0)
      '';
    };

    lsp-haskell = {
      enable = true;
      after = [ "lsp-mode" ];
    };

    lsp-ui = {
      enable = true;
      command = [
        "lsp-ui-mode"
      ];
      init = builtins.readFile ./emacs-inits/lsp-ui.el;
    };

    reason-mode = {
      enable = true;
      after = [ "lsp-mode" ];
      defer = true;
      init = builtins.readFile ./emacs-inits/reason-mode.el;
    };

    tuareg = {
      enable = true;
      after = [ "lsp-mode" "reason-mode" ];
      defer = true;
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
        "<C-s-tab>" = "eyebrowse-prev-window-config";
        "C-S-<tab>" = "eyebrowse-prev-window-config";
      };
      init = builtins.readFile ./emacs-inits/eyebrowse.el;
    };

    haskell-mode = {
      enable = true;
      defer = true;
      after = [ "lsp-haskell" ];
      init = builtins.readFile ./emacs-inits/haskell-mode.el;
    };

    helm-bbdb = {
      enable = true;
      command = [ "helm-bbdb" ];
      after = [ "helm" "bbdb" ];
    };

    yaml-mode = {
      enable = true;
      defer = true;
    };

    gherkin-mode = {
      enable = true;
      defer = true;
      mode = [
        "\"\\\\.feature\\\\'\""
      ];
    };

    csharp-mode = {
      enable = true;
      defer = true;
    };

    fsharp-mode = {
      enable = true;
      defer = true;
      package = epkgs: epkgs.melpaPackages.fsharp-mode.overrideAttrs (old: {
        postPatch = ''
        substituteInPlace fsharp-mode.el --replace "-when-let" "when-let"
        '';
      });
    };

    rust-mode = {
      enable = true;
      after = [ "lsp-mode" ];
      init = builtins.readFile ./emacs-inits/rust-mode.el;
    };

    dockerfile-mode = {
      enable = true;
    };

    term = {
      enable = true;
      bind = {
        "s-v" = "term-paste";
      };
    };

    string-inflection = {
      enable = true;
      demand = true;
      bind = {
        "C-c C" = "string-inflection-camelcase";
        "C-c L" = "string-inflection-lower-camelcase";
      };
    };

    fira-code-mode = {
      enable = true;
      demand = true;
      init = "(global-fira-code-mode)";
    };

    sqlite3 = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    helm-rg = {
      enable = true;
    };

    qml-mode = {
      enable = true;
    };
  };
}
