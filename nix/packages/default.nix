{
  inputs,
  system,
  ...
}:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  inherit pkgs;

  node-packages = import ../node2nix {
    inherit pkgs;
    inherit (pkgs) nodejs;
  };
}
