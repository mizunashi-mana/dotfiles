{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.codex = {
        enable = true;
        package = packages.node-packages."@openai/codex";
      };

      programs.agent-skills = {
        targets.codex.enable = true;
      };
    }
  ];
}
