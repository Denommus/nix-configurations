{ config, pkgs, lib, ... }:
let
  myAspell = pkgs.aspellWithDicts (d: [d.en d.pt_BR]);
  gopanda2 = pkgs.appimageTools.wrapType2 {
    name = "gopanda2";
    src = pkgs.fetchurl {
      url = "https://pandanet-igs.com/gopanda2/download/GoPanda2.AppImage";
      sha256 = "sha256-D6p+aICkolqazYFRTK6f4753Te2IscT8y8o/JLRCdUM=";
    };
    extraPkgs = extra: with extra; [];
  };
  shared = import ../../shared/home.nix { inherit pkgs; };
in
lib.recursiveUpdate
shared
{
  programs.emacs.package = pkgs.emacs28;
  services.emacs.enable = true;

  home.sessionVariablesExtra = ''
    export EDITOR=emacsclient
  '';

  home.packages = with pkgs; [
    octaveFull
    keepassxc
    tdesktop
    spotify
    rustup
    rust-analyzer
    discord
    nodejs
    myAspell
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
    winePackages.staging
    protonup
    hero-lab
  ];

  services.dropbox.enable = true;

  programs.zsh.shellAliases = {
    vim = "emacsclient -t ";
  };

  programs.mu.enable = true;
  programs.mbsync.enable = true;

  accounts.email.maildirBasePath = ".Maildir";
  accounts.email.accounts = {
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
  xdg.desktopEntries.steam-nvidia = {
    name = "steam-nvidia";
    exec = "nvidia-offload steam %U";
    terminal = false;
    icon = "steam";
    type = "Application";
    categories = [ "Network" "FileTransfer" "Game" ];
    mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
    prefersNonDefaultGPU = true;
    comment = "Application for managing and playing games on Steam";
    settings = {
      # I need to be able to add extra groups to be able to use the following attribute
      #Actions = "Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;";
      X-KDE-RunOnDiscreteGpu = "true";
      "Comment[pt_BR]" = "Aplicativo para jogar e gerenciar jogos no Steam";
      "Comment[bg]" = "Приложение за ръководене и пускане на игри в Steam";
      "Comment[cs]" = "Aplikace pro spravování a hraní her ve službě Steam";
      "Comment[da]" = "Applikation til at håndtere og spille spil på Steam";
      "Comment[nl]" = "Applicatie voor het beheer en het spelen van games op Steam";
      "Comment[fi]" = "Steamin pelien hallintaan ja pelaamiseen tarkoitettu sovellus";
      "Comment[fr]" = "Application de gestion et d'utilisation des jeux sur Steam";
      "Comment[de]" = "Anwendung zum Verwalten und Spielen von Spielen auf Steam";
      "Comment[el]" = "Εφαρμογή διαχείρισης παιχνιδιών στο Steam";
      "Comment[hu]" = "Alkalmazás a Steames játékok futtatásához és kezeléséhez";
      "Comment[it]" = "Applicazione per la gestione e l'esecuzione di giochi su Steam";
      "Comment[ja]" = "Steam 上でゲームを管理＆プレイするためのアプリケーション";
      "Comment[ko]" = "Steam에 있는 게임을 관리하고 플레이할 수 있는 응용 프로그램";
      "Comment[no]" = "Program for å administrere og spille spill på Steam";
      "Comment[pt_PT]" = "Aplicação para organizar e executar jogos no Steam";
      "Comment[pl]" = "Aplikacja do zarządzania i uruchamiania gier na platformie Steam";
      "Comment[ro]" = "Aplicație pentru administrarea și jucatul jocurilor pe Steam";
      "Comment[ru]" = "Приложение для игр и управления играми в Steam";
      "Comment[es]" = "Aplicación para administrar y ejecutar juegos en Steam";
      "Comment[sv]" = "Ett program för att hantera samt spela spel på Steam";
      "Comment[zh_CN]" = "管理和进行 Steam 游戏的应用程序";
      "Comment[zh_TW]" = "管理並執行 Steam 遊戲的應用程式";
      "Comment[th]" = "โปรแกรมสำหรับจัดการและเล่นเกมบน Steam";
      "Comment[tr]" = "Steam üzerinden oyun oynama ve düzenleme uygulaması";
      "Comment[uk]" = "Програма для керування іграми та запуску ігор у Steam";
      "Comment[vi]" = "Ứng dụng để quản lý và chơi trò chơi trên Steam";
    };
  };

  nixpkgs.config.allowUnfree = true;
}

