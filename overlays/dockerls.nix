final: prev:
let
  hasLatest =
    (prev ? nodePackages_latest)
    && (prev.nodePackages_latest ? dockerfile-language-server-nodejs);
in {
  nodePackages =
    (prev.nodePackages or {})
    // (if hasLatest then {
      dockerfile-language-server-nodejs =
        prev.nodePackages_latest.dockerfile-language-server-nodejs;
    } else {});
}
