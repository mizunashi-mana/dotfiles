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
          # sandbox の中でも通信とキーチェーンが使えるので、sandbox に頼らず全コマンドを auto_review に通す。
          # on-request だと sandbox の中のコマンドは review されない。
          # 判断の経緯: .ai-agent/surveys/20261022-codex-sandbox-gh-access/README.md
          approval_policy = "untrusted";
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
