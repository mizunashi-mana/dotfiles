{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.awscli = {
        enable = true;
      };

      home.packages = [
        packages.pkgs.ssm-session-manager-plugin
      ];
    }
  ];
}
