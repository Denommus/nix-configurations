self: super:
let gitignoreSrc = super.pkgs.fetchFromGitHub {
      owner = "hercules-ci";
      repo = "gitignore";
      # put the latest commit sha of gitignore Nix library here:
      rev = "c4662e662462e7bf3c2a968483478a665d00e717";
      # use what nix suggests in the mismatch message here:
      sha256 = "sha256:1npnx0h6bd0d7ql93ka7azhj40zgjp815fw2r6smg8ch9p7mzdlx";
    };
    inherit (import gitignoreSrc { inherit (super.pkgs) lib; }) gitignoreSource gitignoreFilter;
in {
  inherit gitignoreSource gitignoreFilter;
}
