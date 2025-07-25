{
  packages,
  inputs,
  ...
}:
{
  homeManagerImports = [
    inputs._1password-shell-plugins.hmModules.default
    {
      programs._1password-shell-plugins = {
        enable = true;
        plugins = [
          packages.pkgs.cachix
        ];
      };
    }
  ];

  nixDarwinModules = [
    {
      programs._1password = {
        enable = true;
      };

      homebrew.casks = [
        "1password"
      ];
    }
  ];

  nixosModules = [
    {
      programs._1password = {
        enable = true;
      };

      programs._1password-gui = {
        enable = true;
      };
    }
  ];
}
