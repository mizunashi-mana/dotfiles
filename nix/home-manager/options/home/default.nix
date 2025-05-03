{ pkgs, ... }: {
  home = {
    sessionVariables = {
      EDITOR = "emacsclient -nw";
    };

    shellAliases = {
      editor = "emacsclient -nw";
    };
  };
}
