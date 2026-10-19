# Codex のステータスライン表示と自動承認

## 目的

Codex でも Claude Code と同じように、ステータスラインにリミット（5h / 週）を常に表示し、コマンドを自動で承認できるようにする。

## 方針

`nix/programs/codex/` だけを変更する。

1. `programs.codex.mutableSettings = true` にする。Codex が `config.toml` に書き込む project の trust や MCP の設定はそのまま残し、Nix で宣言したキーだけを上書きする
2. `programs.codex.settings` に次を書く
   - `tui.status_line = [model-with-reasoning, current-dir, git-branch, context-used, five-hour-limit, weekly-limit]`（Claude の `statusline.sh` と同じ並び）
   - `approval_policy = "on-request"`、`sandbox_mode = "workspace-write"`、`approvals_reviewer = "auto_review"`（Claude の `defaultMode = "auto"` に当たる）
3. `programs.codex.rules.network-read` に `nix/programs/codex/network-read.rules` を置き、ネットワークを使う読み取り系（`gh` の閲覧系、`aws` の読み取り系）だけを `allow` にする
   - Codex が自分で書く `default.rules` には触らない

### 判断メモ

- sandbox は `workspace-write` のままにする。rules の `allow` にマッチしたコマンドは sandbox の外で実行される（Codex の `core/src/exec_policy.rs` の `bypass_sandbox`）。リストに無くて sandbox の外に出るもの（ネットワーク・作業ディレクトリ外への書き込みなど）は auto_review に回る
- 読み取りや作業ディレクトリ内への書き込みは、rules が無くても sandbox の中で承認なしに走る。rules が効くのはネットワークを使う読み取りだけなので、それだけを置く
- 当初は Claude の許可リストから生成し、危険な前方一致を除外リストで除く方式にした。しかしレビューで 2 回続けて漏れが見つかった（`command` / `find` / `sed` など、続いて `actionlint -shellcheck=` / `kubectl --kubeconfig` / `uv pip --python` など）。CLI の多くは引数で設定ファイルやプラグイン、実行するコマンドを指定できるので、除外リストでは漏れが出続ける。そこで Codex 側で許可を明示する方式に切り替えた（ユーザーと相談のうえ）
- git（`git fetch` / `git ls-remote`）は置かない。当初は `origin` に限れば安全と考えたが、読み取り専用になるのは作業ディレクトリ直下の `.git` だけだった。入れ子のリポジトリや `/tmp` のリポジトリの `.git/config` には sandbox の中から書けるので、`uploadpack`・`core.sshCommand`・`core.hooksPath` に仕込んだコマンドが sandbox の外で走る（3 回目のレビューで reviewer が確かめた）
- npm も置かない。プロジェクトの `.npmrc` は sandbox の中から書けるので、`git=` に仕込んだコマンドを `npm view <git の spec>` が起動しうる。作業ディレクトリに置いた設定を読む CLI は、同じ理由で置かない
- gh と aws は、設定（`~/.config/gh`・`~/.aws`）が作業ディレクトリの外にあり、sandbox の中からは書けないので置く
- 前方一致なので後ろの引数は自由に付けられ、`-R` や `--endpoint-url` で任意のホストへ通信できる（作業ディレクトリの内容を外に送れる）。Claude の許可リストと同じ水準として、これは許容する（ユーザーと相談のうえ）
- kubectl（`--kubeconfig` で exec credential plugin を起動できる）と nix（`--option` で評価の設定を変えられる）は置かない
- `danger-full-access` にすると sandbox が無くなり、auto_review の出番もほとんど無くなる。Claude より緩くなるので採らない

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] macOS ホストの home-manager 設定がビルドでき、生成された `config.toml` に上の値が入る
- [x] rules を `codex execpolicy check` にかけ、gh・aws の読み取り系は allow、git・npm・`kubectl`・任意の実行や書き込みにつながるものはマッチしない
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-10-19: 開始。Codex 0.161.0 の設定スキーマと home-manager の codex モジュール（`mutableSettings`・`rules`）を確認し、方針を決定
- 2026-10-19: `nix/programs/codex/default.nix` を実装
  - `darwinConfigurations.nishiyamanomacbook-pro.system` がビルドでき、生成された `codex-config.toml` に `approval_policy` / `approvals_reviewer` / `sandbox_mode` / `tui.status_line` が入ることを確認
  - 生成された `claude-allow.rules` は 193 行。`codex execpolicy check` で `git status` / `gh pr view 1` / `chmod +x foo` は allow、`git push origin x` / `make` / `make install` / `gh pr merge 1` / `for i in 1` / `chmod 777 foo` / `npm install lodash` はマッチしないことを確認
  - `devenv shell lint-all` pass（`nix flake check` で Linux ホストの評価も含む）
- 2026-10-19: PR #322 を作成。1 回目のレビュー（Critical 1 / Warning 1 / Info 2）を受け、任意の実行や書き込みにつながる前方一致を `denyPrefixes` で除外（7fcc5d7）。rules は 100 行になった。Info の 2 件（`mutableSettings` の注意のコメント、空のトークンの除去）も取り込んだ
- 2026-10-19: 2 回目のレビューでも Critical（`actionlint` / `kubectl` / `uv pip list` / `nix` の引数での任意実行）と Warning（`uniq` / `git symbolic-ref` の書き込み、作業ログの古さ）が出た。ユーザーと相談し、Claude の一覧から生成するのをやめ、`network-read.rules` に許可を明示する方式に切り替えた
  - `codex execpolicy check` で、`gh pr view 1` / `git fetch origin` / `git ls-remote origin` / `npm view x` / `aws sts get-caller-identity` は allow になることを確認した。`gh pr merge 1` / `gh run download 1` / `git fetch /tmp/r --upload-pack=x` / `git push origin` / `npm install x` / `aws s3 cp` / `kubectl get po` / `actionlint -shellcheck=x` / `command rm -rf /x` はマッチしない。rules ファイルの `match` / `not_match` も読み込み時に検証される
- 2026-10-19: 3 回目のレビューで Critical（入れ子のリポジトリの `.git/config` を書き換えると、`git fetch origin` で sandbox を抜けられる）と Warning（`--registry` / `--endpoint-url` で任意のホストへ送れる）が出た。ユーザーと相談し、git の rule を外し、任意のホストへの通信は許容してコメントに残すことにした。作業ディレクトリの `.npmrc` に `git=` を仕込める問題があるので、npm も外した
  - `codex execpolicy check` で、`gh pr view 1` / `aws sts get-caller-identity` は allow になることを確認した。`gh pr merge 1` / `aws s3 cp` / `git fetch origin` / `npm view x` / `kubectl get po` はマッチしない
  - Info の `aws configure get`（鍵を出力できる）は直さない。`~/.aws/credentials` は sandbox の中でも読めるので、新しい穴ではないため。`gh run watch` のタイムアウトも直さない。タイムアウトしても実害は無く、Claude 側でも許可しているため
