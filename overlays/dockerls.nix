# Overlay that provides pkgs.dockerfile-language-server
self: super: {
  dockerfile-language-server =
    # prefer the normal nodePackages if present
    (super.nodePackages.dockerfile-language-server-nodejs or null)
    # fall back to nodePackages_latest on channels that use it
    or (super.nodePackages_latest.dockerfile-language-server-nodejs or null);
}
