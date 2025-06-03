{
  pkgs,
  ...
}:
{
  nixDarwinModules = [
    {
      homebrew.casks = [
        "steam"
      ];
    }
  ];
}
