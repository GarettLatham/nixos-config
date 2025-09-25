# Provide pkgs.dockerfile-language-server for nixvim docs
self: super:
let
  np  = if super ? nodePackages        then super.nodePackages        else {};
  npl = if super ? nodePackages_latest then super.nodePackages_latest else {};
  dls =
    if np  ? dockerfile-language-server-nodejs then np.dockerfile-language-server-nodejs
    else if npl ? dockerfile-language-server-nodejs then npl.dockerfile-language-server-nodejs
    else null;
in {
  dockerfile-language-server = dls;
}
