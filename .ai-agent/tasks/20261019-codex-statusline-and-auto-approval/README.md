# Codex のステータスライン表示と自動承認

## 目的

Codex でも Claude Code と同じように、ステータスラインにリミット（5h / 週）を常に表示し、コマンドを自動で承認できるようにする。

## 方針

`nix/programs/codex/default.nix` だけを変更する。

1. `programs.codex.mutableSettings = true` にする。Codex が `config.toml` に書き込む project の trust や MCP の設定はそのまま残し、Nix で宣言したキーだけを上書きする
2. `programs.codex.settings` に次を書く
   - `tui.status_line = [model-with-reasoning, current-dir, git-branch, context-used, five-hour-limit, weekly-limit]`（Claude の `statusline.sh` と同じ並び）
   - `approval_policy = "on-request"`、`sandbox_mode = "workspace-write"`、`approvals_reviewer = "auto_review"`（Claude の `defaultMode = "auto"` に当たる）
3. 許可リスト（`programs.codex.rules`）は置かない。Codex が自分で書く `default.rules` にも触らない

### 判断メモ

- sandbox は `workspace-write` のままにする。読み取りや作業ディレクトリ内への書き込み（`cat` / `rg` / `git status` / `git diff` / ファイル編集 / ローカルのテストなど）は、sandbox の中で承認なしに走る。sandbox の外に出るもの（ネットワーク・作業ディレクトリ外への書き込みなど）は auto_review が判断する
- rules の `allow` にマッチしたコマンドは sandbox の外で実行される（Codex の `core/src/exec_policy.rs` の `bypass_sandbox`）。prefix_rule はサブコマンドまでは判定できるが、その後ろに付くオプションは判定できない。そのため、読み取り専用のサブコマンドに絞っても次のことが起きうる
  - 引数で設定ファイルやプラグイン、実行するコマンドを指定できる（`actionlint -shellcheck=`・`kubectl --kubeconfig`・`uv pip list --python`・`nix --option` など）
  - 作業ディレクトリに置いた設定を読む。入れ子のリポジトリの `.git/config` や `.npmrc` は sandbox の中から書けるので、そこに仕込んだコマンドが sandbox の外で走る
  - 送り先を変えられる（`aws --endpoint-url`・`gh -R <host>/...`・`npm --registry`）
- 経緯: 最初は Claude の許可リストから生成した。次に危険な前方一致を除外リストで除き、さらに Codex 側でネットワークを使う読み取り系だけを明示した。それでもレビューのたびに上の抜け道が見つかった。読み取りは rules が無くても sandbox の中で走るので、rules を置いて得られるのは、ネットワークを使うものの auto_review の待ち時間を省くことだけになる。この利点は小さいと判断し、ユーザーと相談のうえ rules を置かないことにした
- この設定は `default-common.nix` 経由で Linux ホスト（`devcontainer` / `desktop-62r22ok`）にも入る。Linux の Codex sandbox は bubblewrap と user namespace に頼るので、コンテナの中では sandbox が使えず、コマンドが毎回 auto_review に回るか、実行に失敗するおそれがある。確かめたのは macOS だけなので、devcontainer で Codex を使うときに挙動を確かめ、問題があればホストごとに設定を分ける
- `danger-full-access` にすると sandbox が無くなり、auto_review の出番もほとんど無くなる。Claude より緩くなるので採らない

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] macOS ホストの home-manager 設定がビルドでき、生成された `config.toml` に上の値が入る
- [x] レビューを取り込み CI が通った PR → https://github.com/mizunashi-mana/dotfiles/pull/322

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
- 2026-10-19: ユーザーから「任意の通信ができるコマンドは除外したい」と指示があった。gh（`-R`）と aws（`--endpoint-url`）も、後ろのオプションで送り先を変えられる。prefix_rule ではオプションを判定できないので、rules をやめて auto_review に任せることにした（`network-read.rules` を削除）
- 2026-10-19: 4 回目のレビューは Critical 0 / Warning 0 / Info 1。Info（Linux のコンテナで sandbox が使えないおそれ）は、確かめる手段が手元に無いので、判断メモに書き残した
- レビューの取り込みのまとめ
  - 取り込んだもの: 1 回目〜3 回目の Critical / Warning はすべて対応した。最終的には rules をやめた。1 回目の Info 2 件（`mutableSettings` の注意のコメント、空のトークンの除去）、4 回目の Info（判断メモに追記）も取り込んだ
  - 取り込まなかったもの: 2 回目の Info 2 件（claude-code への依存、`claude mcp list`）と 3 回目の Info 2 件（`aws configure get`、`gh run watch` のタイムアウト）は、rules をやめたことで対象が無くなった
