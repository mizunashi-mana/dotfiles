{
  packages,
  inputs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.agent-skills = {
        sources.anthropic = {
          path = inputs.anthropic-skills;
          subdir = "skills";
        };
        skills = {
          enableAll = [ "anthropic" ];
        };
      };
    }
  ];
}
