{
  description = "NixOS + Home-Manager + nixvim (25.05)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
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
        # Your normal system config:
        ./configuration.nix

        # Enable Home-Manager as a NixOS module:
        home-manager.nixosModules.home-manager

        # Expose nixvim's Home-Manager module (25.05 uses 'homeModules'):
        { home-manager.sharedModules = [ nixvim.homeModules.nixvim ]; }

        # Attach your user's Home-Manager config:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.user1 = import ./home/users/user1/home.nix;
        }
      ];
    };
  };
}
