{ pkgs }:
{
  programs.emacs.init = import ./emacs/emacs.nix { inherit pkgs; };
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacs30.override {
    withNativeCompilation = false;
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
    initExtra = ''
      unset RPS1
    '';
  };

  programs.git = {
    enable = true;
    ignores = [ "*~" ".DS_Store" ];
    lfs.enable = true;
    userEmail = "yuridenommus@gmail.com";
    userName = "Yuri Albuquerque";
    extraConfig = {
      pull.ff = "only";
      init.defaultBranch = "main";
    };
  };

  programs.direnv.enable = true;
}
