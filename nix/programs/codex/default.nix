{
  packages,
  ...
}:
{
  homeManagerImports = [
    (
      { lib, ... }:
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

        # auto_review の負担を減らすため、引数や作業ディレクトリの設定で任意の実行・書き込み・通信ができない
        # 読み取り系だけを許可する。allow にマッチしたコマンドは review なしで sandbox の外で走るため、
        # git（入れ子のリポジトリの .git/config のフック）・gh（任意のホストへの通信）・rg（--pre）・
        # file（-C で書き込み）・sort（-o）・tree（-o）・xxd（-r）などは入れない
        programs.codex.rules.read-only =
          lib.concatMapStrings
            (cmd: ''
              prefix_rule(pattern = ["${cmd}"], decision = "allow")
            '')
            [
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

        programs.agent-skills = {
          targets.codex.enable = true;
        };
      }
    )
  ];
}
