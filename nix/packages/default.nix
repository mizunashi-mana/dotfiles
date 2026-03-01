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

  claude-code = inputs.claude-code.packages.${system}.default;

  node-packages = node2nix-pkgs // {
    "@openai/codex" = node2nix-pkgs."@openai/codex-";
    "@playwright/cli" = node2nix-pkgs."@playwright/cli-";
    "@mizunashi_mana/cc-voice-reporter" = node2nix-pkgs."@mizunashi_mana/cc-voice-reporter-";
    "@mizunashi_mana/mcp-html-artifacts-preview" =
      node2nix-pkgs."@mizunashi_mana/mcp-html-artifacts-preview-";
  };
}
