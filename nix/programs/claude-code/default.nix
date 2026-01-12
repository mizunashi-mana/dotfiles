{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.node-packages."@anthropic-ai/claude-code"
      ];

      home.file = {
        ".claude/settings.json" = {
          text = builtins.readFile ./settings.json;
        };
        ".claude/commands" = {
          source = ./commands;
          recursive = true;
        };
        ".claude/agents" = {
          source = ./agents;
          recursive = true;
        };
      };
    }
  ];
}
