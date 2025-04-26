{ pkgs }: {
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = [
        pkgs.vscode-extensions.docker.docker
        pkgs.vscode-extensions.editorconfig.editorconfig
        pkgs.vscode-extensions.github.copilot
        pkgs.vscode-extensions.github.copilot-chat
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.ms-azuretools.vscode-docker
        pkgs.vscode-extensions.ms-vscode-remote.remote-containers
      ];
    };
  };
}
