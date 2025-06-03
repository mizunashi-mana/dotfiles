{
  pkgs,
  ...
}:
{
  nixDarwinModules = [
    {
      homebrew.casks = [
        "google-chrome"
      ];
    }
  ];
}
