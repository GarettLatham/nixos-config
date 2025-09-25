{
  description = "NixOS + Home-Manager (25.05)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Your system config
        ./configuration.nix

        # Enable Home-Manager as a NixOS module
        home-manager.nixosModules.home-manager

        # Attach your user's Home-Manager config
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # NEW: auto-backup any pre-existing files HM would overwrite
          home-manager.backupFileExtension = "hm_bak";
          home-manager.users.user1 = import ./home/users/user1/home.nix;

        }
      ];
    };
  };
}
