{ pkgs, ... }: {
  home = {
    sessionPath = [
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      editor = "emacsclient -nw";
    };
  };
}
