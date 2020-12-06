{ config, pkgs, ... }:
let myAspell = pkgs.aspellWithDicts (d: [d.en d.pt_BR]);
    nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};
in
{

  imports = [ nur-no-pkgs.repos.rycee.hmModules.emacs-init ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.emacs.init = import ./emacs-init.nix { inherit pkgs; };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";

  home.sessionVariablesExtra = ''
    export EDITOR=emacsclient
  '';

  home.packages = with pkgs; [
    keepassxc
    tdesktop
    spotify
    steam
    rustup
    discord
    signal-desktop
    nodejs
    myAspell
    nodePackages.node2nix
    gcc
    python3
    okular
    cloc
    kdeApplications.gwenview
    kdeApplications.spectacle
    vlc
    obs-studio
    libreoffice
    zip
    unzip
    corefonts
    google-chrome
    krita
    exercism
    texlive.combined.scheme-full
    rsync
    screenfetch
    postman
    usbutils
  ];

  programs.firefox.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      theme = "mortalscumbag";
      plugins = [
        "git"
        "rsync"
        "django"
        "yarn"
      ];
    };
  };

  programs.git = {
    enable = true;
    ignores = [ "*~" ];
    lfs.enable = true;
    userEmail = "yuridenommus@gmail.com";
    userName = "Yuri Albuquerque";
    extraConfig = {
      pull.ff = "only";
    };
  };

  programs.emacs.enable = true;

  services.emacs.enable = true;
  services.emacs.client.enable = true;

  services.dropbox.enable = true;


  programs.zsh.shellAliases = {
    vim = "emacsclient -t ";
  };

  programs.mu.enable = true;
  programs.mbsync.enable = true;

  accounts.email.maildirBasePath = ".Maildir";
  accounts.email.accounts = {
    ba = {
      userName = "yurialbuquerque@brickabode.com";
      address = "yurialbuquerque@brickabode.com";
      gpg.key = "4F4DB1BE3862279F7E6971E4727A35C53FCE6775";
      gpg.signByDefault = true;
      imap.host = "imap.gmail.com";
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        patterns = [ "*" "!\"[Gmail]/Spam\"" "!\"[Gmail]/Important\"" "!\"[Gmail]/Starred\"" ];
        extraConfig.account.Timeout = 60;
      };
      folders = {
        inbox = "INBOX";
        trash = "[Gmail]/Trash";
        sent = "[Gmail]/Sent Mail";
        drafts = "[Gmail]/Drafts";
      };
      passwordCommand = "gpg --no-tty -qd ~/.authinfo.gpg | sed -n 's,^machine imap.gmail.com login yurialbuquerque@brickabode.com .*password \\\\([^ ]*\\\\).*,\\\\1,p'";
      smtp.host = "smtp.gmail.com";
      mu.enable = true;
      realName = "Yuri Albuquerque";
    };

    personal = {
      userName = "yuridenommus@gmail.com";
      address = "yuridenommus@gmail.com";
      gpg.key = "4F4DB1BE3862279F7E6971E4727A35C53FCE6775";
      gpg.signByDefault = true;
      imap.host = "imap.gmail.com";
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        patterns = [ "*" "!\"[Gmail]/Spam\"" "!\"[Gmail]/Importante\"" "![Gmail]/Com estrela" ];
        extraConfig.account.Timeout = 60;
      };
      folders = {
        inbox = "INBOX";
        trash = "[Gmail]/Lixeira";
        sent = "[Gmail]/E-mails enviados";
        drafts = "[Gmail]/Rascunhos";
      };
      passwordCommand = "gpg --no-tty -qd ~/.authinfo.gpg | sed -n 's,^machine imap.gmail.com login yuridenommus@gmail.com .*password \\\\([^ ]*\\\\).*,\\\\1,p'";
      smtp.host = "smtp.gmail.com";
      mu.enable = true;
      realName = "Yuri Albuquerque";
      primary = true;
    };
  };
}
