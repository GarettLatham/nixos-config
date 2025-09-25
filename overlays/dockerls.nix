# overlays/dockerls.nix
self: super: {
  dockerfile-language-server =
    if (super ? nodePackages) && (super.nodePackages ? dockerfile-language-server-nodejs)
    then super.nodePackages.dockerfile-language-server-nodejs
    else if (super ? nodePackages_latest) && (super.nodePackages_latest ? dockerfile-language-server-nodejs)
    then super.nodePackages_latest.dockerfile-language-server-nodejs
    else null; # still OK: nixvim only needs the attribute to exist during docs eval
}
