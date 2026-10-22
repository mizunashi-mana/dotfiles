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
          # approval_policy は書かない。書くとプロジェクトの trust_level より優先される。
          # trust_level = "untrusted" のプロジェクトでは、rules に無いコマンドがすべて auto_review に回る。
          # sandbox の中でも通信とキーチェーンが使えるので、sandbox ではなく review で持ち出しを防ぐ。
          # 判断の経緯: .ai-agent/tasks/20261022-codex-sandbox-network-access/README.md
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

        # allow の rule は置かない。allow にマッチしたコマンドは review なしで sandbox の外で走り、
        # 名前だけの呼び出しは PATH（devenv の node_modules/.bin など作業ディレクトリの中）の偽物に化けうるため。
        # 終わらずにセッションが止まるので、追いかける tail は review に回す。
        # -f が最初の引数のときだけ当たる（tail -n 5 -f や --follow=name には当たらない）
        rules.tail-follow = ''
          prefix_rule(pattern = ["tail", ["-f", "-F", "--follow"]], decision = "prompt")
        '';
      };

      programs.agent-skills = {
        targets.codex.enable = true;
      };
    }
  ];
}
