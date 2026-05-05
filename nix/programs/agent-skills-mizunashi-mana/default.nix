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
            "autodev-init"
            "detect-context-rot"
            "detect-missed-skill-triggers"
            "detect-rework-and-violations"
            "detect-token-hotspots"
            "merge-dependabot-bump-pr"
            "recommend-bash-allowlist"
          ];
        };
      };
    }
  ];
}
