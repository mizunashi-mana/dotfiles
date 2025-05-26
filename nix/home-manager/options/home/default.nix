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
  };
}
