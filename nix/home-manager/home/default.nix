{ packages, ... }:
{
  home = {
    stateVersion = "25.05";

    sessionPath = [
      "$HOME/.nix-profile/bin"
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "emacsclient -nw --alternate-editor 'nvim'";
    };

    shellAliases = {
      editor = "emacsclient -nw --alternate-editor 'nvim'";
    };

    file = {
      "Workspace/MyWork/.keep".text = "";
    };

    packages = [
      packages.pkgs.cacert
    ];
  };
}
