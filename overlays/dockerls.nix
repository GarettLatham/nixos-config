# maps to the available package on your channel so that
# pkgs.dockerfile-language-server exists during evaluation.
final: prev:
let
  candidate =
    if prev ? dockerfile-language-server-nodejs then
      prev.dockerfile-language-server-nodejs
    else if prev ? nodePackages && prev.nodePackages ? dockerfile-language-server-nodejs then
      prev.nodePackages.dockerfile-language-server-nodejs
    else
      null;
in {
  dockerfile-language-server =
    if candidate != null then candidate
    else throw "No dockerfile-language-server(-nodejs) found in your nixpkgs (25.05).";
}
