{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.claude-code = {
        enable = true;
        package = packages.node-packages."@anthropic-ai/claude-code";
      };

      home.file = {
        ".claude/settings.json" = {
          source = ./settings.json;
        };
        ".claude/statusline.sh" = {
          source = ./statusline.sh;
          executable = true;
        };
        ".claude/skills" = {
          source = ./skills;
          recursive = true;
        };
      };

      programs.agent-skills = {
        targets.claude.enable = true;
      };
    }
  ];
}
