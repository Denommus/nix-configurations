{
  config,
  pkgs,
  lib,
  ...
}:
let
  myAspell = pkgs.aspellWithDicts (d: [
    d.en
    d.pt_BR
  ]);
  shared = import ../../shared/home.nix { inherit pkgs; };
in
lib.recursiveUpdate shared {
  home.sessionVariablesExtra = ''
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    export PATH="/Users/yuri/.foundry/bin:/Users/yuri/.local/share/solana/install/active_release/bin:$PATH"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';
  home.packages = with pkgs; [
    myAspell
    rustup
    texlive.combined.scheme-full
    texlivePackages.beamer
    nixpkgs-review
  ];

  home.activation = {
    #emacsApp = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #  sudo rm -rf /Users/yurialbuquerque/Applications/Emacs.app
    #  cp -r ${config.programs.emacs.finalPackage}/Applications/Emacs.app /Users/yurialbuquerque/Applications/Emacs.app
    #  defaults write com.apple.dock ResetLaunchPad -bool true;killall Dock
    #'';
  };
}
