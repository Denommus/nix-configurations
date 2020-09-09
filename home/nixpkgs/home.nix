{ config, pkgs, ... }:
let myAspell = pkgs.aspellWithDicts (d: [d.en d.pt_BR]);
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";

  home.sessionVariables = {
    EDITOR = "emacsclient";
  };

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
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      theme = "mortalscumbag";
    };
  };

  programs.git = {
    enable = true;
    ignores = [ "*~" ];
    lfs.enable = true;
    userEmail = "yuridenommus@gmail.com";
    userName = "Yuri Albuquerque";
  };

  programs.emacs.enable = true;

  services.emacs.enable = true;
  services.emacs.client.enable = true;

  services.dropbox.enable = true;


  programs.zsh.shellAliases = {
    vim = "emacsclient -t ";
  };
}
