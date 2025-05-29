{
  description = "NixOS Adriel's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-edge.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    eachPkgs = nixpkgs.lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit overlays system;
          config.allowUnfree = true;
        }
    );
  in {
    
    nixosConfigurations.benihime = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/benihime/configuration.nix
	{
            nixpkgs.pkgs = eachPkgs."x86_64-linux";
        }
      ];
    };

    homeConfigurations = {
      "adriel@benihime" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        pkgs =  eachPkgs."x86_64-linux";
        modules = [./hosts/benihime/adriel/home-configuration.nix];
      };
    };
  };
}
