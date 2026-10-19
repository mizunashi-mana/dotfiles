{
  ...
}:
{
  homeManagerImports = [
    (
      { config, lib, ... }:
      let
        # Codex で allow に一致したコマンドは sandbox の外で実行されるため、Claude の許可リストから
        # 次の前方一致に当たるものを除く。読み取りや作業ディレクトリ内への書き込みは、除いても
        # sandbox の中で承認なしに走る。
        denyPrefixes = map (lib.splitString " ") [
          # シェルの断片
          "do"
          "done"
          "for"
          # 任意のコマンドやスクリプトを実行できる（find -exec、sed の e コマンド、rg --pre、git の hook など）
          "agy"
          "command"
          "convert"
          "find"
          "git commit"
          "magick"
          "npx"
          "playwright-cli"
          "pre-commit"
          "prek"
          "rg"
          "sed"
          "swift"
          "tar"
          "uv run"
          "xargs"
          "xcodebuild"
          "yarn"
          # ファイルを書き込む、または出力先を引数で指定できる（sort -o、tree -o、git diff --output など）
          "chmod"
          "cp"
          "gh run download"
          "git add"
          "git apply"
          "git diff"
          "git log"
          "git mv"
          "git remote prune"
          "git reset"
          "git show"
          "iconv"
          "mkdir"
          "mv"
          "nkf"
          "npm pack"
          "npm rebuild"
          "npm uninstall"
          "ollama pull"
          "sort"
          "touch"
          "tree"
          "unzip"
          "uv remove"
          "xxd"
        ];
        isDenied = tokens: builtins.any (deny: lib.lists.hasPrefix deny tokens) denyPrefixes;

        # Claude Code の許可リストの Bash(<prefix>:*) を Codex の prefix_rule に変換する。
        # Codex のルールは前方一致しか持たないため、完全一致の項目は引数付きの呼び出しまで
        # 許してしまわないよう除く。
        claudeBashPrefixes = lib.pipe config.programs.claude-code.settings.permissions.allow [
          (map (builtins.match "Bash\\((.*):\\*\\)"))
          (builtins.filter (m: m != null))
          (map (m: builtins.filter (t: t != "") (lib.splitString " " (builtins.head m))))
          (builtins.filter (tokens: !isDenied tokens))
        ];
        mkPrefixRule = tokens: ''prefix_rule(pattern=${builtins.toJSON tokens}, decision="allow")'';
      in
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
            claude-allow = lib.concatLines (map mkPrefixRule claudeBashPrefixes);
          };
        };

        programs.agent-skills = {
          targets.codex.enable = true;
        };
      }
    )
  ];
}
