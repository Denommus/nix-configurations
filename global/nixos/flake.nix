{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #home-manager.inputs.nur.follows = "nur";
  };

  outputs = inputs: {
    nixosConfigurations.yuri-nixos = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        { nixpkgs.overlays = [ inputs.nur.overlay ]; }
        inputs.home-manager.nixosModules.home-manager (let
        in {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.yuri = import ./yuri/home.nix;
          };
        })
      ];
    };
  };
}
