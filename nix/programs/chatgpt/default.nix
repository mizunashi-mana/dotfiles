{
  pkgs,
  ...
}:
{
  nixDarwinModules = [
    {
      homebrew.casks = [
        "chatgpt"
      ];
    }
  ];
}
