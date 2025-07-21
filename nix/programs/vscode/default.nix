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
            packages.pkgs.vscode-extensions.astro-build.astro-vscode
            packages.pkgs.vscode-extensions.charliermarsh.ruff
            packages.pkgs.vscode-extensions.editorconfig.editorconfig
            packages.pkgs.vscode-extensions.jnoortheen.nix-ide
            packages.pkgs.vscode-extensions.ms-azuretools.vscode-docker
            packages.pkgs.vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
            packages.pkgs.vscode-extensions.ms-python.python
            packages.pkgs.vscode-extensions.ms-toolsai.jupyter
            packages.pkgs.vscode-extensions.ms-vscode.hexeditor
            packages.pkgs.vscode-extensions.ms-vscode.makefile-tools
            packages.pkgs.vscode-extensions.redhat.vscode-yaml
            packages.pkgs.vscode-extensions.stylelint.vscode-stylelint
            packages.vscode-extensions.vscode-marketplace.anthropic.claude-code
            packages.vscode-extensions.vscode-marketplace.dbaeumer.vscode-eslint
            packages.vscode-extensions.vscode-marketplace.eamodio.gitlens
            packages.vscode-extensions.vscode-marketplace.github.copilot
            packages.vscode-extensions.vscode-marketplace.github.copilot-chat
            packages.vscode-extensions.vscode-marketplace.github.vscode-github-actions
            packages.vscode-extensions.vscode-marketplace.ms-playwright.playwright
            packages.vscode-extensions.vscode-marketplace.ms-vscode-remote.remote-containers
            packages.vscode-extensions.vscode-marketplace.pbkit.vscode-pbkit
            packages.vscode-extensions.vscode-marketplace.tamasfe.even-better-toml
          ];

          userSettings = {
            "update.mode" = "none";
            "workbench.startupEditor" = "none";
            "terminal.integrated.defaultProfile.osx" = "fish";
            "terminal.integrated.defaultProfile.linux" = "fish";
            "editor.wordWrap" = "on";
            "github.copilot.chat.localeOverride" = "ja";
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
              "charliermarsh.ruff"
              "dbaeumer.vscode-eslint"
              "eamodio.gitlens"
              "editorconfig.editorconfig"
              "github.copilot"
              "github.vscode-github-actions"
              "jnoortheen.nix-ide"
              "ms-playwright.playwright"
              "redhat.vscode-yaml"
              "tamasfe.even-better-toml"
            ];
          };
        };
      };
    }
  ];
}
