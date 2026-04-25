{
  ...
}:
{
  homeManagerImports = [
    {
      programs.codex = {
        enable = true;
      };

      programs.agent-skills = {
        targets.codex.enable = true;
      };
    }
  ];
}
