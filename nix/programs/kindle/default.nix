{
  pkgs,
  ...
}:
{
  nixDarwinModules = [
    {
      homebrew.masApps = {
        Kindle = 302584613;
      };
    }
  ];
}
