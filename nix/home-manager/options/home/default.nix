{ pkgs, ... }: {
  home = {
    sessionVariables = {
      EDITOR = "emacsclient -nw";
    };
  };
}
