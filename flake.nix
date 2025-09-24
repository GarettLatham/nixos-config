inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  home-manager.url = "github:nix-community/home-manager/release-25.05";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";

  nixvim.url = "github:nix-community/nixvim";
  nixvim.inputs.nixpkgs.follows = "nixpkgs";
};

# ...

modules = [
  ./configuration.nix
  home-manager.nixosModules.home-manager

  # Use the new output name on 25.05:
  { home-manager.sharedModules = [ nixvim.homeModules.nixvim ]; }

  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.user1 = import ./home/users/user1/home.nix;
  }
];
