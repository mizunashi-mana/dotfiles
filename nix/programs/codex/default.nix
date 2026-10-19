{
  ...
}:
{
  homeManagerImports = [
    {
      programs.codex = {
        enable = true;
        # Codex が config.toml に書き込む project の trust や MCP の設定を残す。
        # 宣言した値は上書きでマージされるだけなので、ここから消したキーは実ファイルに残る
        mutableSettings = true;
        settings = {
          approval_policy = "on-request";
          approvals_reviewer = "auto_review";
          sandbox_mode = "workspace-write";
          tui.status_line = [
            "model-with-reasoning"
            "current-dir"
            "git-branch"
            "context-used"
            "five-hour-limit"
            "weekly-limit"
          ];
        };
        rules = {
          network-read = ./network-read.rules;
        };
      };

      programs.agent-skills = {
        targets.codex.enable = true;
      };
    }
  ];
}
