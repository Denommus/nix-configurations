{ makeDesktopItem, fetchurl, winePackages, wrap-wine, lib }:
let
  file = fetchurl {
    url = "https://www.wolflair.com/download/hp/hl89h_win_install.exe";
    sha256 = "sha256-P6qsHr+npu2VD6EE6VJSIc/PM5ncXJ0ydFMBnnUmJXk=";
  };
in wrap-wine {
  name = "hero-lab";
  executable = "$WINEPREFIX/drive_c/Program\ Files/Hero\ Lab/HeroLab.exe";
  firstrunScript = ''
    pushd $WINEPREFIX/drive_c
    ${winePackages.staging}/bin/wine ${file}
  '';
}
