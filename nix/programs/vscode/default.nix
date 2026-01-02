{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.vscode = {
        enable = true;

        profiles.default = {
          enableExtensionUpdateCheck = false;
          enableUpdateCheck = false;

          extensions = [
            packages.pkgs.vscode-extensions.jnoortheen.nix-ide
            packages.pkgs.vscode-extensions.ms-vscode.hexeditor
            packages.pkgs.vscode-extensions.ms-vscode.makefile-tools
            packages.vscode-extensions.vscode-marketplace.astro-build.astro-vscode
            packages.vscode-extensions.vscode-marketplace.bradlc.vscode-tailwindcss
            packages.vscode-extensions.vscode-marketplace.charliermarsh.ruff
            packages.vscode-extensions.vscode-marketplace.cweijan.dbclient-jdbc
            packages.vscode-extensions.vscode-marketplace.dbaeumer.vscode-eslint
            packages.vscode-extensions.vscode-marketplace.eamodio.gitlens
            packages.vscode-extensions.vscode-marketplace.editorconfig.editorconfig
            packages.vscode-extensions.vscode-marketplace.esbenp.prettier-vscode
            packages.vscode-extensions.vscode-marketplace.github.copilot-chat
            packages.vscode-extensions.vscode-marketplace.github.vscode-github-actions
            packages.vscode-extensions.vscode-marketplace.graphql.vscode-graphql-syntax
            packages.vscode-extensions.vscode-marketplace.htmlhint.vscode-htmlhint
            packages.vscode-extensions.vscode-marketplace.ms-azuretools.vscode-docker
            packages.vscode-extensions.vscode-marketplace.ms-kubernetes-tools.vscode-kubernetes-tools
            packages.vscode-extensions.vscode-marketplace.ms-playwright.playwright
            packages.vscode-extensions.vscode-marketplace.ms-toolsai.jupyter
            packages.vscode-extensions.vscode-marketplace.ms-python.python
            packages.vscode-extensions.vscode-marketplace.ms-vscode-remote.remote-containers
            packages.vscode-extensions.vscode-marketplace.pbkit.vscode-pbkit
            packages.vscode-extensions.vscode-marketplace.prisma.prisma
            packages.vscode-extensions.vscode-marketplace.redhat.vscode-yaml
            packages.vscode-extensions.vscode-marketplace.rust-lang.rust-analyzer
            packages.vscode-extensions.vscode-marketplace.stylelint.vscode-stylelint
            packages.vscode-extensions.vscode-marketplace.tamasfe.even-better-toml
            packages.vscode-extensions.vscode-marketplace.unifiedjs.vscode-mdx
            packages.vscode-extensions.vscode-marketplace.vitest.explorer
          ];

          userSettings = {
            "update.mode" = "none";
            "extensions.autoUpdate" = false;
            "workbench.startupEditor" = "none";
            "terminal.integrated.defaultProfile.osx" = "fish";
            "terminal.integrated.defaultProfile.linux" = "fish";
            "editor.wordWrap" = "on";
            "github.copilot.enable" = {
              markdown = true;
            };
            "github.copilot.chat.localeOverride" = "ja";
            "github.copilot.nextEditSuggestions.enabled" = true;
            "ruff.interpreter" = [
              "ruff"
              "\${workspaceFolder}/.venv/bin/ruff"
              "\${workspaceFolder}/.devenv/state/venv/bin/ruff"
            ];
            "javascript.preferences.importModuleSpecifier" = "non-relative";
            "typescript.preferences.importModuleSpecifier" = "non-relative";
            "python.venvFolders" = [
              "\${workspaceFolder}/.devenv/state"
              "\${workspaceFolder}/.venv"
            ];
            "remote.autoForwardPortsSource" = "hybrid";
            "docker.extension.enableComposeLanguageServer" = false;
            "dev.containers.defaultExtensions" = [
              "anthropic.claude-code"
              "astro-build.astro-vscode"
              "bradlc.vscode-tailwindcss"
              "charliermarsh.ruff"
              "dbaeumer.vscode-eslint"
              "eamodio.gitlens"
              "editorconfig.editorconfig"
              "esbenp.prettier-vscode"
              "github.copilot"
              "github.copilot-chat"
              "github.vscode-github-actions"
              "htmlhint.vscode-htmlhint"
              "jnoortheen.nix-ide"
              "ms-playwright.playwright"
              "pbkit.vscode-pbkit"
              "redhat.vscode-yaml"
              "stylelint.vscode-stylelint"
              "tamasfe.even-better-toml"
            ];
            "terminal.integrated.suggest.enabled" = false;
          };
        };
      };
    }
  ];
}
