# Codex のサンドボックスでネットワークを許可する

## 目的

Codex の `workspace-write` サンドボックスの中からネットワークに出られるようにし、gh などがサンドボックスで止まらないようにする。

発端は logix-analytics-developer-agent のセッションだった。gh が sandbox の中でキーチェーンを読めずに「トークンが無効」と失敗し、Codex がそれを認証切れと受け取って、PR を作れないと結論づけた。

## 方針

- `nix/programs/codex/default.nix` の `settings` に `sandbox_workspace_write.network_access = true` を足す。生成される `config.toml` には `[sandbox_workspace_write] network_access = true` として出る
- あわせて `approval_policy` を `"on-request"` から `"untrusted"` に変え、すべてのコマンドを auto_review に通す
- auto_review の負担を減らすため、Claude の許可リストのうち、引数や作業ディレクトリの設定で任意の実行・書き込み・通信ができない読み取り系だけを `programs.codex.rules.read-only` で allow にする（`basename` / `cat` / `comm` / `diff` / `echo` / `grep` / `head` / `jq` / `ls` / `od` / `printf` / `pwd` / `readlink` / `strings` / `tail` / `wc` / `which`）

### 判断メモ

調査は [.ai-agent/surveys/20261022-codex-sandbox-gh-access/](../../surveys/20261022-codex-sandbox-gh-access/README.md) にまとめた。

- #322 では「sandbox の中は承認なし、sandbox の外に出るもの（ネットワークなど）は auto_review」としていた。この PR で、その前提を変える
- `network_access = true` にすると、sandbox の中でも通信とキーチェーン（`com.apple.SecurityServer`）が使えるようになる。gh の認証も通るが、`security find-generic-password -w` でキーチェーンの値も読めるようになる（`codex sandbox` で確かめた）
- `on-request` では、sandbox の中で走るコマンドは review されない。`on-request` のまま `network_access = true` にすると、「読んで任意のホストへ送る」が review なしで通る。そこで `untrusted` にして、sandbox に頼らず、すべてのコマンドを auto_review に通す
- 指示（AGENTS.md）で「gh の認証エラーは sandbox の外での実行を求め直す」と教える案もあった。ツールごとに指示が増え続けるので採らなかった
- 受け入れること
  - `ls` / `cat` / `git status` などの読み取りも毎回 auto_review を通るので、待ち時間とトークンが増える
  - auto_review が承認したコマンドは、通信とキーチェーンが使える sandbox の中で走る。持ち出しを防ぐのは auto_review の判断だけになる
- rules の allow にマッチしたコマンドは、review なしで sandbox の外で走る（`core/src/exec_policy.rs` の `bypass_sandbox`。「review は省くが sandbox の中で走らせる」指定は `prefix_rule` に無い）。#322 で Claude の一覧から生成して抜け道が尽きなかったので、今回は手で選んだ最小限にした。git（入れ子のリポジトリの `.git/config` の fsmonitor や pager）、gh（`gh pr view <任意のホストの URL>` で review なしに送れる）、rg（`--pre`）、file（`-C`）、sort（`-o`）、tree（`-o`）、xxd（`-r`）、`command` / `xargs`（任意のコマンドを走らせる）は入れない
- リダイレクトやコマンド置換を含むシェルスクリプトは、単純なコマンドの並びとみなされないので、rules の allow には当たらない（`shell-command/src/bash.rs` の `parse_shell_lc_plain_commands`）
- 残る課題: `~/.codex/rules/default.rules` に溜まった allow（`gh api` / `gh pr` / `git push` など）にマッチしたコマンドは、`untrusted` でも review なしで sandbox の外で走る。このファイルは Nix の外にあり、この PR では触らない
- この設定は `default-common.nix` 経由で Linux ホスト（`devcontainer` / `desktop-62r22ok`）にも入る。確かめたのは macOS だけ

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `nishiyamanomacbook-pro` と `nishiyamanomacbook-air` の darwin 設定がビルドでき、生成された `codex-config.toml` に `approval_policy = "untrusted"`、`[sandbox_workspace_write]`、`network_access = true` が入っている
- [x] `codex execpolicy check` で、`cat README.md` / `ls -la` / `grep -r foo .` / `jq . x.json` は allow、`git status` / `gh pr view 1` / `rg --pre x foo` / `sort -o x y` / `file -C` はマッチしない
- [x] `codex sandbox` で、`network_access = true` のとき sandbox の中から `gh auth status` / `gh api user` が通る
- [x] レビューを取り込み CI が通った PR → https://github.com/mizunashi-mana/dotfiles/pull/325

## 作業ログ

- 2026-10-22: 開始
- 2026-10-22: lint-all と Pro・Air のビルドが通り、生成された `codex-config.toml` に `[sandbox_workspace_write]` と `network_access = true` が入ることを確かめた。PR #325 を作成
- 2026-10-22: 1 回目のレビューは Critical 0 / Warning 1 / Info 2
  - Warning（#322 の方針と食い違うのに、判断が記録されていない）: 発端と影響を調べた（survey）。ユーザーと相談し、`network_access = true` は入れたまま、`approval_policy` を `untrusted` にして全コマンドを auto_review に通すことにした。判断メモと `default.nix` のコメントに残した
  - Info 1（作業ログが「開始」だけ。`config.toml` と `codex-config.toml` の呼び方がずれている）: 作業ログを足し、完了条件の呼び方を `codex-config.toml` にそろえた
  - Info 2（Linux ホストを確かめていない）: 判断メモに書いた
- 2026-10-22: 上の変更の CI が通った。ユーザーの依頼で、auto_review の負担を減らす読み取り系の rules（`read-only.rules`）を足した。lint-all と Pro・Air のビルドが通り、`codex execpolicy check` で判定を確かめた
