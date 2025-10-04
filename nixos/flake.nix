{
  description = "Hybrid NixOS flake with stable and some unstable packages";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs-stable,
    nixpkgs-unstable,
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
                unstablePkgs.neovim
                unstablePkgs.prettier
              ];
          })
        ];
      };
    };
  };
}
