{
  description = "NixOS + Home-Manager with nixvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # Extra channel just for nixvim and (optionally) a few packages
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nixvim module so HM can configure Neovim declaratively
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Your normal NixOS config
        ./configuration.nix

        # Home Manager as a NixOS module
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Your user
          home-manager.users.user1 = { pkgs, ... }: {
            # Pull in nixvim’s HM module and your HM config
            imports = [
              nixvim.homeManagerModules.nixvim
              ./home/users/user1/home.nix
            ];
          };
        }
      ];
    };
  };
}
