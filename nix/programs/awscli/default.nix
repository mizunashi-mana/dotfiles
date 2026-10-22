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
        packages.pkgs-stable.aws-sam-cli
        packages.pkgs.ssm-session-manager-plugin
      ];
    }
  ];
}
