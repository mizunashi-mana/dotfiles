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
        # The unstable package fails its own tests since the click update; switch back once it builds.
        packages.pkgs-stable.aws-sam-cli
        packages.pkgs.ssm-session-manager-plugin
      ];
    }
  ];
}
