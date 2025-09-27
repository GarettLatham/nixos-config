# flake.nix
{
  description = "NixOS + Home-Manager (25.05)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NEW: pull newer plugin builds only
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
  let
    system = "x86_64-linux";

    # Overlay to take just a few vimPlugins from unstable
    newerVimPlugins = final: prev: let
      unstable = nixpkgs-unstable.legacyPackages.${system}.vimPlugins;
    in {
      vimPlugins = prev.vimPlugins // {
        project-nvim = unstable.project-nvim;
        luasnip      = unstable.luasnip;
        # add more here later if needed
      };
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix

        # enable HM as NixOS module
        home-manager.nixosModules.home-manager

        # make overlay available to both NixOS + HM
        ({ ... }: {
          nixpkgs.overlays = [ newerVimPlugins ];
        })

        # your HM wiring
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm_bak";
          home-manager.users.user1 = import ./home/users/user1/home.nix;
        }
      ];
    };
  };
}
