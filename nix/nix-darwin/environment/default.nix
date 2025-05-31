{
  pkgs,
  username,
  homedir,
}:
{
  environment = {
    systemPackages = [
      pkgs.fish
      pkgs.devenv
    ];

    shells = [
      pkgs.fish
    ];
  };
}
