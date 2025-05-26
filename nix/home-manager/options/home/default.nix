{ pkgs, ... }:
{
  home = {
    sessionPath = [
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
  };
}
