{
  pkgs,
  username,
  homedir,
  inputs,
  ...
}:
{
  modules = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        home.stateVersion = "25.05";

        home.username = username;
        home.homeDirectory = homedir;
      };
    }
  ];
}
