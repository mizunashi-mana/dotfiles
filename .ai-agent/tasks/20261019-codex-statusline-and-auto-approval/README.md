# Codex のステータスライン表示と自動承認

## 目的

Codex でも Claude Code と同じように、ステータスラインにリミット（5h / 週）を常に表示し、コマンドを自動で承認できるようにする。

## 方針

`nix/programs/codex/default.nix` だけを変更する。

1. `programs.codex.mutableSettings = true` にする。Codex が `config.toml` に書き込む project の trust や MCP の設定はそのまま残し、Nix で宣言したキーだけを上書きする
2. `programs.codex.settings` に次を書く
   - `tui.status_line = [model-with-reasoning, current-dir, git-branch, context-used, five-hour-limit, weekly-limit]`（Claude の `statusline.sh` と同じ並び）
   - `approval_policy = "on-request"`、`sandbox_mode = "workspace-write"`、`approvals_reviewer = "auto_review"`（Claude の `defaultMode = "auto"` に当たる）
3. `programs.codex.rules.claude-allow` で、`config.programs.claude-code.settings.permissions.allow` の `Bash(<prefix>:*)` を `prefix_rule(pattern=[...], decision="allow")` に変換して書き出す。Claude 側の一覧を唯一の出どころにして、両者の許可範囲をそろえる
   - Codex のルールは前方一致しか持たないので、完全一致の項目（`Bash(make)` など）は入れない。入れると引数付きの呼び出しまで許してしまうため
   - シェルの断片（`for:*`・`do echo:*`・`done:*` など）は入れない
   - 任意のコマンドを実行できるもの（`command`・`find`・`sed`・`xargs`・`tar`・`npx` など）と、ファイルを書き込むもの・出力先を引数で指定できるもの（`cp`・`mv`・`chmod`・`sort`・`tree`・`git diff` など）は、Codex 側の除外リスト `denyPrefixes` で除く
   - Codex が自分で書く `default.rules` には触らない

### 判断メモ

- sandbox は `workspace-write` のままにする。rules の `allow` にマッチしたコマンドは sandbox の外で実行される（Codex の `core/src/exec_policy.rs` の `bypass_sandbox`）ので、許可リストのコマンドはネットワークを使っても止まらない。リストに無くて sandbox の外に出るもの（ネットワーク・作業ディレクトリ外への書き込みなど）だけが auto_review に回る
- Claude には sandbox が無いので、同じ許可リストでも Codex では「sandbox を外す許可」に意味が変わる。そのため Claude の一覧をそのまま写さず、任意の実行や書き込みにつながる前方一致を除く。読み取りや作業ディレクトリ内への書き込みは、除いても sandbox の中で承認なしに走るので、除くことで困ることはほとんど無い
- 除外リスト方式なので、Claude 側に足した項目は Codex でも既定で sandbox の外で通る。Claude に項目を足すときは `denyPrefixes` に当たるかを見る
- `git fetch` / `git ls-remote` は `--upload-pack=<cmd>` で任意のコマンドを起動できるが、ネットワークの読み取りは rules を置く主な目的なので残す（既知のリスク）
- `danger-full-access` にすると sandbox が無くなり、auto_review の出番もほとんど無くなる。Claude より緩くなるので採らない

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] macOS ホストの home-manager 設定がビルドでき、生成された `config.toml` に上の値が入る
- [x] 生成した rules を `codex execpolicy check` にかけ、`git status` は allow、`git push`・`make`・任意の実行や書き込みにつながるものはマッチしない
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-10-19: 開始。Codex 0.161.0 の設定スキーマと home-manager の codex モジュール（`mutableSettings`・`rules`）を確認し、方針を決定
- 2026-10-19: `nix/programs/codex/default.nix` を実装
  - `darwinConfigurations.nishiyamanomacbook-pro.system` がビルドでき、生成された `codex-config.toml` に `approval_policy` / `approvals_reviewer` / `sandbox_mode` / `tui.status_line` が入ることを確認
  - 生成された `claude-allow.rules` は 193 行。`codex execpolicy check` で `git status` / `gh pr view 1` / `chmod +x foo` は allow、`git push origin x` / `make` / `make install` / `gh pr merge 1` / `for i in 1` / `chmod 777 foo` / `npm install lodash` はマッチしないことを確認
  - `devenv shell lint-all` pass（`nix flake check` で Linux ホストの評価も含む）
