{
  packages,
  inputs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.agent-skills = {
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
            "autodev-init"
            "merge-dependabot-bump-pr"
          ];
        };
      };
    }
  ];
}
