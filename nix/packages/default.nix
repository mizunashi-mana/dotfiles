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

  node2nix-pkgs = import ../node2nix {
    inherit pkgs;
    inherit (pkgs) nodejs;
  };
in
{
  inherit pkgs;

  node-packages = node2nix-pkgs // {
    "@anthropic-ai/claude-code" = node2nix-pkgs."@anthropic-ai/claude-code-";
  };
}
