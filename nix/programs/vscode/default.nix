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
          extensions = [
            packages.pkgs.vscode-extensions.astro-build.astro-vscode
            packages.pkgs.vscode-extensions.charliermarsh.ruff
            packages.pkgs.vscode-extensions.dbaeumer.vscode-eslint
            packages.pkgs.vscode-extensions.eamodio.gitlens
            packages.pkgs.vscode-extensions.editorconfig.editorconfig
            packages.pkgs.vscode-extensions.github.copilot
            packages.pkgs.vscode-extensions.github.copilot-chat
            packages.pkgs.vscode-extensions.github.vscode-github-actions
            packages.pkgs.vscode-extensions.jnoortheen.nix-ide
            packages.pkgs.vscode-extensions.ms-azuretools.vscode-docker
            packages.pkgs.vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
            packages.pkgs.vscode-extensions.ms-python.python
            packages.pkgs.vscode-extensions.ms-toolsai.jupyter
            packages.pkgs.vscode-extensions.ms-vscode.hexeditor
            packages.pkgs.vscode-extensions.ms-vscode.makefile-tools
            packages.pkgs.vscode-extensions.ms-vscode-remote.remote-containers
            packages.pkgs.vscode-extensions.redhat.vscode-yaml
            packages.pkgs.vscode-extensions.stylelint.vscode-stylelint
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
          };
        };
      };
    }
  ];
}
