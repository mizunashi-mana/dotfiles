{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.codex = {
        enable = true;
        package = packages.codex;
        # Codex が config.toml に書き込む project の trust や MCP の設定を残す。
        # 宣言した値は上書きでマージされるだけなので、ここから消したキーは実ファイルに残る
        mutableSettings = true;
        settings = {
          approval_policy = "on-request";
          approvals_reviewer = "auto_review";
          sandbox_mode = "workspace-write";
          sandbox_workspace_write.network_access = true;
          tui.status_line = [
            "model-with-reasoning"
            "current-dir"
            "git-branch"
            "context-used"
            "five-hour-limit"
            "weekly-limit"
          ];
        };
      };

      programs.agent-skills = {
        targets.codex.enable = true;
      };
    }
  ];
}
