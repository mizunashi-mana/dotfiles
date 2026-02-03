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
        packages.pkgs.aws-sam-cli
        packages.pkgs.ssm-session-manager-plugin
      ];
    }
  ];
}
