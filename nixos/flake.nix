{
  description = "Hybrid NixOS flake with stable, some unstable packages, and home-manager";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = {
    self,
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    stablePkgs = import nixpkgs-stable {inherit system;};
    unstablePkgs = import nixpkgs-unstable {inherit system;};
  in {
    nixosConfigurations = {
      nixos = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          ({
            config,
            pkgs,
            ...
          }: {
            environment.systemPackages = with pkgs;
              [
                vim
              ]
              ++ [
                unstablePkgs.hello
                unstablePkgs.prettier
              ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          })
        ];
      };
    };
  };
}
