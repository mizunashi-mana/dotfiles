{ packages, default-editor, ... }:
{
  home = {
    stateVersion = "25.05";

    sessionPath = [
      "$HOME/.nix-profile/bin"
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = default-editor;
    };

    shellAliases = {
      editor = default-editor;
    };

    file = {
      "Workspace/MyWork/.keep".text = "";
    };

    packages = [
      packages.pkgs.cacert
    ];
  };
}
