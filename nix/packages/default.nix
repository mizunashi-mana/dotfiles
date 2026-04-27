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

  cc-voice-reporter = pkgs.callPackage ./cc-voice-reporter.nix { };
  mcp-html-artifacts-preview = pkgs.callPackage ./mcp-html-artifacts-preview.nix { };
  playwright-cli = pkgs.callPackage ./playwright-cli.nix { };
}
