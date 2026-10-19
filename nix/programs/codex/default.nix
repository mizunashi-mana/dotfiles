{
  ...
}:
{
  homeManagerImports = [
    (
      { config, lib, ... }:
      let
        # Claude Code の許可リストの Bash(<prefix>:*) を Codex の prefix_rule に変換する。
        # Codex のルールは前方一致しか持たないため、完全一致の項目は引数付きの呼び出しまで
        # 許してしまわないよう除く。シェルの断片（for / do / done）も除く。
        claudeBashPrefixes = lib.pipe config.programs.claude-code.settings.permissions.allow [
          (map (builtins.match "Bash\\((.*):\\*\\)"))
          (builtins.filter (m: m != null))
          (map (m: lib.splitString " " (builtins.head m)))
          (builtins.filter (
            tokens:
            !builtins.elem (builtins.head tokens) [
              "do"
              "done"
              "for"
            ]
          ))
        ];
        mkPrefixRule = tokens: ''prefix_rule(pattern=${builtins.toJSON tokens}, decision="allow")'';
      in
      {
        programs.codex = {
          enable = true;
          # Codex が config.toml に書き込む project の trust や MCP の設定を残す
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
