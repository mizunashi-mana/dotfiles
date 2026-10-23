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

        # auto_review の負担を減らすため、次を満たすコマンドを allow にする。
        # - 消したり上書きしたりしない
        # - 外へ公開しない（push・PR やコメントの作成・マージなどをしない）
        # - 書き込みは手元のメタデータとキャッシュ（refs/remotes など）だけ
        # - 止めない限り終わらないもの（tail -f など）ではない
        # allow にマッチしたコマンドは review なしで sandbox の外で走る。
        # git fetch などは相手を origin に固定する。相手がローカルパスだと --upload-pack（省略形や = つきも効く）で
        # 手元の任意のコマンドが 1 回で走るため。origin を手元のパスに向けるには回りくどい手順が要る。
        # 引数で送り先を変えられること（gh -R・URL・git fetch <URL>）、入れ子のリポジトリの .git/config で
        # git から任意の実行ができること、git diff / log / show の --output で任意の場所に書けることは、
        # そこに至る回りくどい手順の途中で auto_review が止める見込みで受け入れている。
        # rg（--pre）・file（-C）・sort（-o）・tree（-o）・xxd（-r）・command・xargs などは入れない。
        # 名前で許可するので、PATH や絶対パスで作業ディレクトリに置いた偽物を呼ばれうるが、
        # 人が実行するときも気付けない穴なので受け入れる。
        # 判断の経緯: .ai-agent/tasks/20261022-shared-agent-allowlist/README.md
        rules.allowed = ''
          prefix_rule(pattern = ["basename"], decision = "allow")
          prefix_rule(pattern = ["cat"], decision = "allow")
          prefix_rule(pattern = ["comm"], decision = "allow")
          prefix_rule(pattern = ["date"], decision = "allow")
          prefix_rule(pattern = ["diff"], decision = "allow")
          prefix_rule(pattern = ["echo"], decision = "allow")
          prefix_rule(pattern = ["gh", "cache", "list"], decision = "allow")
          prefix_rule(pattern = ["gh", "issue", "list"], decision = "allow")
          prefix_rule(pattern = ["gh", "issue", "view"], decision = "allow")
          prefix_rule(pattern = ["gh", "label", "list"], decision = "allow")
          prefix_rule(pattern = ["gh", "pr", "checks"], decision = "allow")
          prefix_rule(pattern = ["gh", "pr", "diff"], decision = "allow")
          prefix_rule(pattern = ["gh", "pr", "list"], decision = "allow")
          prefix_rule(pattern = ["gh", "pr", "view"], decision = "allow")
          prefix_rule(pattern = ["gh", "release", "list"], decision = "allow")
          prefix_rule(pattern = ["gh", "release", "view"], decision = "allow")
          prefix_rule(pattern = ["gh", "repo", "view"], decision = "allow")
          prefix_rule(pattern = ["gh", "run", "list"], decision = "allow")
          prefix_rule(pattern = ["gh", "run", "view"], decision = "allow")
          prefix_rule(pattern = ["gh", "run", "watch"], decision = "allow")
          prefix_rule(pattern = ["gh", "search"], decision = "allow")
          prefix_rule(pattern = ["git", "--version"], decision = "allow")
          prefix_rule(pattern = ["git", "check-ignore"], decision = "allow")
          prefix_rule(pattern = ["git", "diff"], decision = "allow")
          prefix_rule(pattern = ["git", "fetch", "origin"], decision = "allow")
          prefix_rule(pattern = ["git", "log"], decision = "allow")
          prefix_rule(pattern = ["git", "ls-files"], decision = "allow")
          prefix_rule(pattern = ["git", "ls-remote", "origin"], decision = "allow")
          prefix_rule(pattern = ["git", "ls-tree"], decision = "allow")
          prefix_rule(pattern = ["git", "merge-base"], decision = "allow")
          prefix_rule(pattern = ["git", "remote", "get-url"], decision = "allow")
          prefix_rule(pattern = ["git", "remote", "prune", "origin"], decision = "allow")
          prefix_rule(pattern = ["git", "rev-parse"], decision = "allow")
          prefix_rule(pattern = ["git", "show"], decision = "allow")
          prefix_rule(pattern = ["git", "status"], decision = "allow")
          prefix_rule(pattern = ["git", "submodule", "status"], decision = "allow")
          prefix_rule(pattern = ["grep"], decision = "allow")
          prefix_rule(pattern = ["head"], decision = "allow")
          prefix_rule(pattern = ["jq"], decision = "allow")
          prefix_rule(pattern = ["ls"], decision = "allow")
          prefix_rule(pattern = ["lsof"], decision = "allow")
          prefix_rule(pattern = ["od"], decision = "allow")
          prefix_rule(pattern = ["otool"], decision = "allow")
          prefix_rule(pattern = ["pgrep"], decision = "allow")
          prefix_rule(pattern = ["printf"], decision = "allow")
          prefix_rule(pattern = ["ps"], decision = "allow")
          prefix_rule(pattern = ["pwd"], decision = "allow")
          prefix_rule(pattern = ["readlink"], decision = "allow")
          prefix_rule(pattern = ["sleep"], decision = "allow")
          prefix_rule(pattern = ["strings"], decision = "allow")
          prefix_rule(pattern = ["tail"], decision = "allow")
          prefix_rule(pattern = ["test"], decision = "allow")
          prefix_rule(pattern = ["true"], decision = "allow")
          prefix_rule(pattern = ["wc"], decision = "allow")
          prefix_rule(pattern = ["which"], decision = "allow")

          # gh の送り先のホストを変える引数は review に回す。決まった位置の、= を使わない形にしか当たらない
          prefix_rule(pattern = ["gh", ["cache", "issue", "label", "pr", "release", "repo", "run"], ["checks", "diff", "list", "view", "watch"], ["-R", "--repo"]], decision = "prompt")

          # 終わらずにセッションが止まるので、追いかける tail は review に回す。
          # -f が最初の引数のときだけ当たる（tail -n 5 -f や --follow=name には当たらない）
          prefix_rule(pattern = ["tail", ["-f", "-F", "--follow"]], decision = "prompt")
        '';
      };

      programs.agent-skills = {
        targets.codex.enable = true;
      };
    }
  ];
}
