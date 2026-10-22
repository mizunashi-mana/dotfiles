{
  packages,
  ...
}:
{
  homeManagerImports = [
    (
      { lib, ... }:
      let
        # auto_review の負担を減らすため、引数や作業ディレクトリの設定で任意の実行・書き込み・通信ができない
        # 読み取り系だけを許可する。allow にマッチしたコマンドは review なしで sandbox の外で走るため、
        # git（入れ子のリポジトリの .git/config のフック）・gh（-R や URL で任意のホストへ送れる）・rg（--pre）・
        # file（-C で書き込み）・sort（-o）・tree（-o）・xxd（-r）などは入れない。
        # 名前で許可するので、PATH や絶対パスで作業ディレクトリに置いた偽物を呼ばれうるが、
        # 人が実行するときも気付けない穴なので受け入れる
        readOnlyCommands = [
          "basename"
          "cat"
          "comm"
          "diff"
          "echo"
          "grep"
          "head"
          "jq"
          "ls"
          "od"
          "printf"
          "pwd"
          "readlink"
          "strings"
          "tail"
          "wc"
          "which"
        ];
      in
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

          rules.read-only =
            lib.concatMapStrings (cmd: ''
              prefix_rule(pattern = ["${cmd}"], decision = "allow")
            '') readOnlyCommands
            # 終わらずにセッションが止まるので、追いかける tail は review に回す。
            # -f が最初の引数のときだけ当たる（tail -n 5 -f や --follow=name には当たらない）
            + ''
              prefix_rule(pattern = ["tail", ["-f", "-F", "--follow"]], decision = "prompt")
            '';
        };

        programs.agent-skills = {
          targets.codex.enable = true;
        };
      }
    )
  ];
}
