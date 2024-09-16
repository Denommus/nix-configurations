{ config, pkgs, lib, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [ vim
      gitFull
      gnupg
      nodePackages.npm
      nodejs
      nixfmt-rfc-style
      lldb
      exercism
      nixd
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  services.nix-daemon.enable = true;
  services.activate-system.enable = true;
  nix = {
    optimise.automatic = true;
    extraOptions = ''
    experimental-features = nix-command flakes
    '';
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nixpkgs.config.allowUnfree = true;

  homebrew = {
    enable = true;
    brews = [
      "libiconv"
      "libgit2"
      "pkg-config"
      "docker-compose"
      "awscli"
      "libpq"
      "protobuf"
      "libusb"
      "ripgrep"
      "coreutils"
    ];
    casks = [
      "element"
      "slack"
      "docker"
      "spotify"
      "zoom"
      "discord"
      "anki"
      "krita"
      "steam"
      "obs"
    ];
    taps = [
      # "homebrew/cask"
    ];
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
  };

  fonts.packages = with pkgs; [
    anonymousPro
    ubuntu_font_family
    wqy_microhei
    wqy_zenhei
    ttf-tw-moe
    fira-code
    fira-code-symbols
  ];

  users.users."yuri" = {
    home = "/Users/yuri";
    shell = "/bin/zsh";
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}
