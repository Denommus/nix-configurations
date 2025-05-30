{
  description = "Yuri's Nix system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nur, home-manager, darwin, ... }@inputs:
  let
    nur-no-pkgs = (system: import nur {
      pkgs = null;
      nurpkgs = import nixpkgs {
        inherit system;
      };
    });
  in {
    nixosConfigurations.yuri-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        {
          nixpkgs.overlays = [
            (nur.overlays.default)
            (final: prev: {
              wrap-wine = (import ./linux/wine-packages/wrap-wine.nix { pkgs = final; });
            })
            (final: prev: {
              hero-lab = final.callPackage ./linux/wine-packages/hero-lab.nix {};
            })
          ];
        }
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.yuri = {
	            imports = [
	              ./linux/yuri/home.nix
		            (nur-no-pkgs "x86_64-linux").repos.rycee.hmModules.emacs-init
	            ];
	          };
          };
        }
      ];
    };

    darwinConfigurations.MacBook-Pro-de-Yuri = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        ./darwin-configuration.nix
        { nixpkgs.overlays = [ nur.overlays.default ]; }
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              system = "aarch64-darwin";
            };
            users.yuri = {
              imports = [
                ./darwin/yurialbuquerque/home.nix
                (nur-no-pkgs "aarch64-darwin").repos.rycee.hmModules.emacs-init
              ];
            };
          };
        }
      ];
    };
  };
}
