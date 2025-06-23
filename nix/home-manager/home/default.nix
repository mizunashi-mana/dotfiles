{ packages, ... }:
{
  home = {
    stateVersion = "25.05";

    sessionPath = [
      "$HOME/.nix-profile/bin"
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "emacsclient -nw";
    };

    shellAliases = {
      editor = "emacsclient -nw";
    };

    file = {
      "Workspace/MyWork/.keep".text = "";
    };

    packages = [
      packages.pkgs.cacert
    ];
  };
}
