{ config, pkgs, ... }:
let myAspell = pkgs.aspellWithDicts (d: [d.en d.pt_BR]);
    nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};
    gopanda2 = pkgs.appimageTools.wrapType2 {
      name = "gopanda2";
      src = pkgs.fetchurl {
        url = "https://pandanet-igs.com/gopanda2/download/GoPanda2.AppImage";
        sha256 = "sha256-D6p+aICkolqazYFRTK6f4753Te2IscT8y8o/JLRCdUM=";
      };
      extraPkgs = extra: with extra; [];
    };
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
    octaveFull
    keepassxc
    tdesktop
    spotify
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
    gwenview
    spectacle
    ark
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
    usbutils
    firefox-bin
    python3.pkgs.pygments
    dosbox
    skypeforlinux
    mpc_cli
    adoptopenjdk-jre-bin
    docker-compose
    anki-bin
    mplayer
    protontricks
    dolphin-emu-beta
    slack
    zoom-us
    gopanda2
    wineWowPackages.staging
  ];

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
      init.defaultBranch = "main";
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

  services.mpd = {
    enable = true;
    musicDirectory = "/home/yuri/Músicas";
    network.startWhenNeeded = true;
  };

  # Opens steam with nvidia-offload
  xdg.desktopEntries.steam = {
    name = "steam";
    exec = "nvidia-offload steam %U";
    extraConfig = builtins.readFile ./steam/steam.desktop;
    terminal = false;
    icon = "steam";
    type = "Application";
    categories = [ "Network" "FileTransfer" "Game" ];
    mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
    comment = "Application for managing and playing games on Steam";
  };
}
