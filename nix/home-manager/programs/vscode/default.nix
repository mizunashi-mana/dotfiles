{ pkgs }: {
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = [
        pkgs.vscode-extensions.dbaeumer.vscode-eslint
        pkgs.vscode-extensions.editorconfig.editorconfig
        pkgs.vscode-extensions.github.copilot
        pkgs.vscode-extensions.github.copilot-chat
        pkgs.vscode-extensions.github.vscode-github-actions
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.ms-azuretools.vscode-docker
        pkgs.vscode-extensions.ms-vscode-remote.remote-containers
        pkgs.vscode-extensions.ms-vscode.hexeditor
        pkgs.vscode-extensions.ms-toolsai.jupyter
        pkgs.vscode-extensions.ms-python.python
        pkgs.vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
        pkgs.vscode-extensions.ms-vscode.makefile-tools
        pkgs.vscode-extensions.redhat.vscode-yaml
      ];
    };
  };
}
