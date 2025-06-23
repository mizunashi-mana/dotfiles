{
  packages,
  username,
  homedir,
  inputs,
  extra-imports ? [ ],
  ...
}:
{
  modules = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        home.username = username;
        home.homeDirectory = homedir;

        imports =
          (import ../../home-manager {
            inherit packages;
          }).imports
          ++ extra-imports;
      };
    }
  ];
}
