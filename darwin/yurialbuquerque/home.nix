{ config, pkgs, lib, unstable-pkgs, ... }:
let
  myAspell = pkgs.aspellWithDicts (d: [d.en d.pt_BR]);
  shared = import ../../shared/home.nix { inherit pkgs; };
in
lib.recursiveUpdate
shared
{
  programs.emacs.package = unstable-pkgs.emacs28;

  home.sessionVariablesExtra = ''
    export EDITOR=emacsclient
  '';
  home.packages = with pkgs; [
    myAspell
    rustup
    rust-analyzer
    texlive.combined.scheme-full
    python310Packages.pygments
  ];

  home.activation = {
    emacsApp = lib.hm.dag.entryAfter ["writeBoundary"] ''
      sudo rm -rf /Users/yurialbuquerque/Applications/Emacs.app
      cp -r ${config.programs.emacs.finalPackage}/Applications/Emacs.app /Users/yurialbuquerque/Applications/Emacs.app
      defaults write com.apple.dock ResetLaunchPad -bool true;killall Dock
    '';
  };
}
