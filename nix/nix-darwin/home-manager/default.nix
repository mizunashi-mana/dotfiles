{
  packages,
  username,
  homedir,
  inputs,
  extra-imports ? [ ],
  ...
}:
let
  home-manager = import ../../home-manager {
    inherit packages;
  };
in
{
  modules = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        home.username = username;
        home.homeDirectory = homedir;

        imports = home-manager.imports ++ extra-imports;
      };
    }
  ];
}
