{
  pkgs,
  username,
  homedir,
  brews,
  casks,
}:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    brews = brews;

    casks = casks;
  };
}
