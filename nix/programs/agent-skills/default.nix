{
  packages,
  inputs,
  ...
}:
{
  homeManagerImports = [
    inputs.agent-skills.homeManagerModules.default
    {
      programs.agent-skills = {
        enable = true;
      };
    }
  ];
}
