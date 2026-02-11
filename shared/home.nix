{ pkgs }:
{
  programs.emacs.init = import ./emacs/emacs.nix { inherit pkgs; };
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacs30.override {
    withNativeCompilation = false;
    withImageMagick = true;
  };
  services.emacs.client.enable = true;

  home.sessionVariablesExtra = ''
    export EDITOR=emacsclient
  '';

  home.stateVersion = "22.11";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "sudo"
      ];
    };
    initContent = ''
      unset RPS1
    '';
  };

  programs.git = {
    enable = true;
    ignores = [
      "*~"
      ".DS_Store"
    ];
    lfs.enable = true;
    settings = {
      user = {
        email = "yuridenommus@gmail.com";
        name = "Yuri Albuquerque";
      };
      pull.ff = "only";
      init.defaultBranch = "main";
      user.signingkey = "4F4DB1BE3862279F7E6971E4727A35C53FCE6775";
      commit.gpgsign = true;
    };
  };

  programs.direnv.enable = true;
}
