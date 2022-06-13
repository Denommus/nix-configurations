{ pkgs }:
{
  programs.emacs.init = import ./emacs/emacs.nix { inherit pkgs; };
  programs.emacs.enable = true;
  services.emacs.client.enable = true;

  home.sessionVariablesExtra = ''
  export EDITOR=emacsclient
  '';

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
      ];
    };
  };

  programs.git = {
    enable = true;
    ignores = [ "*~" ];
    lfs.enable = true;
    userEmail = "yuri.albuquerque@nextroll.com";
    userName = "Yuri Albuquerque";
    extraConfig = {
      pull.ff = "only";
      init.defaultBranch = "main";
    };
  };
}
