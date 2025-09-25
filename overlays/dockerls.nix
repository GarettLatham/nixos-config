final: prev: {
  dockerfile-language-server =
    prev."dockerfile-language-server-nodejs"
    or (prev.nodePackages."dockerfile-language-server-nodejs"
    or (prev.nodePackages_latest."dockerfile-language-server-nodejs"
    or (throw "dockerfile-language-server-nodejs not found in this nixpkgs")));
}
