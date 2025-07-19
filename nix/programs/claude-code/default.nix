{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.node-packages."@anthropic-ai/claude-code"
        packages.node-packages."ccusage"
      ];

      home.file = {
        ".claude/settings.json" = {
          text = builtins.readFile ./settings.json;
        };
      };
    }
  ];
}
