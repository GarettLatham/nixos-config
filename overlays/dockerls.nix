final: prev: {
  nodePackages = (prev.nodePackages or {}) // {
    # alias to the “latest” node set where this package exists
    dockerfile-language-server-nodejs =
      prev.nodePackages_latest.dockerfile-language-server-nodejs;
  };
}
