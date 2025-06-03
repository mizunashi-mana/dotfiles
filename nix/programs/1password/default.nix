{
  pkgs,
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
          pkgs.gh
          pkgs.cachix
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
}
