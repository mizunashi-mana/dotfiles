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

  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  node2nix-pkgs = import ../node2nix {
    inherit pkgs;
    inherit (pkgs) nodejs;
  };

  vscode-extensions =
    (import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    }).nix-vscode-extensions;
in
{
  inherit pkgs pkgs-stable vscode-extensions;

  node-packages = node2nix-pkgs // {
    "@anthropic-ai/claude-code" = node2nix-pkgs."@anthropic-ai/claude-code-";
    "ccusage" = node2nix-pkgs."ccusage-";
    "@google/gemini-cli" = node2nix-pkgs."@google/gemini-cli-";
  };
}
