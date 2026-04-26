{
  packages,
  inputs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.agent-skills = {
        sources.mizunashi-mana-agent-coach = {
          path = inputs.mizunashi-mana-skills;
          subdir = "plugins/agent-coach/skills";
          filter.maxDepth = 1;
        };
        sources.mizunashi-mana-autodev = {
          path = inputs.mizunashi-mana-skills;
          subdir = "plugins/autodev/skills";
          filter.maxDepth = 1;
        };
        sources.mizunashi-mana-merge-dependabot-bump-pr = {
          path = inputs.mizunashi-mana-skills;
          subdir = "plugins/merge-dependabot-bump-pr/skills";
          filter.maxDepth = 1;
        };
        skills = {
          enable = [
            "agent-coach"
            "autodev-init"
            "merge-dependabot-bump-pr"
          ];
        };
      };
    }
  ];
}
