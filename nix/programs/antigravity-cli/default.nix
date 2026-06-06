{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.antigravity-cli = {
        enable = true;
        package = packages.pkgs.antigravity-cli;
      };

      programs.agent-skills = {
        targets.antigravity.enable = true;
      };
    }
  ];
}
