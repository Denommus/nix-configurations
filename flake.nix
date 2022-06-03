{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-21.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = { self, nixpkgs, nur, home-manager, nixpkgs-darwin, darwin }@inputs:
  let
    nur-no-pkgs = import nur {
      pkgs = null;
      nurpkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    };
  in {
    nixosConfigurations.yuri-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        { nixpkgs.overlays = [ nur.overlay ]; }
        home-manager.nixosModules.home-manager (let
        in {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.yuri = {
	            imports = [
	              ./linux/yuri/home.nix
		            nur-no-pkgs.repos.rycee.hmModules.emacs-init
	            ];
	          };
          };
        })
      ];
    };

    darwinConfigurations."Yuris-MacBook-Pro" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        ./darwin-configuration.nix
        { nixpkgs.overlays = [ nur.overlay ]; }
        home-manager.darwinModules.home-manager ({
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              unstable-pkgs = nixpkgs.legacyPackages.x86_64-darwin;
              system = "x86_64-darwin";
            };
            users.yurialbuquerque = {
              imports = [
                ./darwin/yurialbuquerque/home.nix
                nur-no-pkgs.repos.rycee.hmModules.emacs-init
              ];
            };
          };
        })
      ];
    };
  };
}
