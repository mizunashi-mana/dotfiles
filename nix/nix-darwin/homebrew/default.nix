{
  pkgs,
  username,
  homedir,
}:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
}
