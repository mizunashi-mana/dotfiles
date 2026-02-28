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
    "@openai/codex" = node2nix-pkgs."@openai/codex-";
    "@playwright/cli" = node2nix-pkgs."@playwright/cli-";
    "@mizunashi_mana/cc-voice-reporter" = node2nix-pkgs."@mizunashi_mana/cc-voice-reporter-";
    "claude-mermaid" = node2nix-pkgs."claude-mermaid-".override {
      buildInputs = [ pkgs.esbuild ];
      preRebuild = ''
        # Skip puppeteer browser download in sandbox
        export PUPPETEER_SKIP_DOWNLOAD=1

        # Provide esbuild binary from Nix instead of platform-specific npm package
        mkdir -p node_modules/esbuild/bin
        cp ${pkgs.esbuild}/bin/esbuild node_modules/esbuild/bin/esbuild
        chmod +x node_modules/esbuild/bin/esbuild
        # Prevent esbuild install script from running
        echo '#!/usr/bin/env node' > node_modules/esbuild/install.js
      '';
    };
  };
}
