{
  description = "NixOS + Home-Manager + nixvim (flakes)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix

        # Enable Home-Manager as a NixOS module
        home-manager.nixosModules.home-manager

        # Provide nixvim’s HM module so programs.nixvim works
        { home-manager.sharedModules = [ nixvim.homeManagerModules.nixvim ]; }

        # Hook your user’s Home-Manager config
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.user1 = import ./home/users/user1/home.nix;
        }
      ];
    };
  };
}
