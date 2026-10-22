# Codex のサンドボックスでネットワークを許可する

## 目的

Codex の `workspace-write` サンドボックスの中からネットワークに出られるようにし、gh などがサンドボックスで止まらないようにする。

発端は logix-analytics-developer-agent のセッションだった。gh が sandbox の中でキーチェーンを読めずに「トークンが無効」と失敗し、Codex がそれを認証切れと受け取って、PR を作れないと結論づけた。

## 方針

- `nix/programs/codex/default.nix` の `settings` に `sandbox_workspace_write.network_access = true` を足す。生成される `config.toml` には `[sandbox_workspace_write] network_access = true` として出る
- `approval_policy` を Nix から消し、プロジェクトの `trust_level` で決まるようにする。`trust_level = "untrusted"` のプロジェクトでは、rules に無いコマンドがすべて auto_review に回る。今 `trusted` のプロジェクトは、ユーザーが個別に `untrusted` にする
- rules の allow は置かない。`tail -f` / `-F` / `--follow` は終わらないので、`programs.codex.rules.tail-follow` で `prompt` にする

### 判断メモ

調査は [.ai-agent/surveys/20261022-codex-sandbox-gh-access/](../../surveys/20261022-codex-sandbox-gh-access/README.md) にまとめた。

- #322 では「sandbox の中は承認なし、sandbox の外に出るもの（ネットワークなど）は auto_review」としていた。この PR で、その前提を変える
- `network_access = true` にすると、sandbox の中でも通信とキーチェーン（`com.apple.SecurityServer`）が使えるようになる。gh の認証も通るが、`security find-generic-password -w` でキーチェーンの値も読めるようになる（`codex sandbox` で確かめた）
- `on-request` では、sandbox の中で走るコマンドは review されない。`on-request` のまま `network_access = true` にすると、「読んで任意のホストへ送る」が review なしで通る。そこで `untrusted` で、sandbox に頼らず、rules に無いコマンドをすべて auto_review に通す
- Codex 0.163.0 では、`approval_policy = "untrusted"` を config に書くと `approval_policy = "untrusted" is no longer supported` で起動しない（`core/src/config/mod.rs` の `UnsupportedUntrustedApprovalPolicyError`）。`untrusted` になるのは、`approval_policy` を書かずに、プロジェクトの `trust_level` が `"untrusted"` のときだけ。照合は作業ディレクトリかリポジトリのルートのパスの完全一致
- `approval_policy` を書かず、どのプロジェクトにも当たらない場所は `on-request` になる（`AskForApproval` の既定値）。TUI で初めて開いたときの trust の確認で信頼すると `trusted`（`on-request`）になる。そこでは review なしで持ち出せる。ユーザーと相談し、このリスクを受け入れた
- `mutableSettings` なので、Nix から消したキーは `~/.codex/config.toml` に残る。2026-10-22 に、実ファイルの `approval_policy = "on-request"` を手で消した。ほかのホストで適用するときも、同じ行を消す必要がある
- 指示（AGENTS.md）で「gh の認証エラーは sandbox の外での実行を求め直す」と教える案もあった。ツールごとに指示が増え続けるので採らなかった
- 受け入れること
  - `untrusted` のプロジェクトでは、読み取り（`cat` / `git status` など）も毎回 auto_review を通るので、待ち時間とトークンが増える
  - auto_review が承認したコマンドは、通信とキーチェーンが使える sandbox の中で走る。持ち出しを防ぐのは auto_review の判断だけになる
- 読み取り系（`cat` / `ls` / `grep` など 17 個）を rules の allow にして reviewer の負担を減らす案を試したが、やめた
  - allow にマッチしたコマンドは、review なしで sandbox の外で走る（`core/src/exec_policy.rs` の `bypass_sandbox`。「review は省くが sandbox の中で走らせる」指定は `prefix_rule` に無い）
  - 名前だけの `cat` は PATH で解決されないまま rule に当たり、実行時に PATH の先頭から探される。このリポジトリの devenv では PATH の先頭が相対パスの `node_modules/.bin` なので、作業ディレクトリに置いた偽物が sandbox の外で走る。`host_executable` は絶対パスで呼んだときにしか効かない
  - gh の読み取り系（`gh pr diff` など）も、`-R` や PR の URL で任意のホストへ送れる（`gh pr diff https://example.com/owner/repo/pull/1` が `https://example.com/api/graphql` に送ることを確かめた）ので、入れない
  - #322 でも、Claude の一覧から生成して抜け道が尽きなかった。allow は置かないことにした
- `tail -f` の `prompt` は、`tail -n 5 -f` のように `-f` が 2 番目に無いと当たらない。セッションが止まるのを減らすためのもので、安全のためのものではない
- `~/.codex/rules/default.rules` に溜まっていた allow（`gh api` / `gh pr` / `git push` など）は、プロジェクトが `untrusted` でも review なしで sandbox の外で走る。ユーザーと相談し、2026-10-22 に手で一度だけ消した。Nix では固定しないので、承認のときに「今後も許可」を選ぶと、Codex がまた書き足す
- この設定は `default-common.nix` 経由で Linux ホスト（`devcontainer` / `desktop-62r22ok`）にも入る。確かめたのは macOS だけ

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `nishiyamanomacbook-pro` と `nishiyamanomacbook-air` の darwin 設定がビルドでき、生成された `codex-config.toml` に `approval_policy` が無く、`[sandbox_workspace_write]`・`network_access = true` が入っている
- [x] `codex execpolicy check` で、`tail -f` / `tail -F` は prompt、`tail -n 5 a` はマッチしない
- [x] 一時的な `CODEX_HOME` で、`approval_policy` を書かずにプロジェクトを `trust_level = "untrusted"` にすると、`codex exec` の表示が `approval: untrusted` / `sandbox: workspace-write ... (network access enabled)` になる
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
- 2026-10-22: `gh pr diff` などを rules に足す相談があった。`-R` や URL で任意のホストへ送れるので入れないことにした。`~/.codex/rules/default.rules` をユーザーの依頼で手で消した（バックアップあり）
- 2026-10-22: 2 回目のレビューは Critical 1 / Warning 2 / Info 2
  - Critical（0.163.0 は `approval_policy = "untrusted"` を受け付けず、Codex が起動しない）: 手元で再現した。ユーザーと相談し、`approval_policy` を消して、プロジェクトの `trust_level` で `untrusted` にする形に変えた。実ファイルの `approval_policy = "on-request"` も手で消した
  - Warning 1（絶対パスで呼ぶと basename で rule に当たる）: `host_executable` で実体のパスを絞った
  - Warning 2（survey と README が `untrusted` を書ける前提に立っている）: 両方を直した
  - Info 1（`tail -f` が allow になり、セッションが止まる）: `prompt` の rule を足した
  - Info 2（survey の結論が二重に読める）: 見出しを「調査時点の推奨」に変えた
- 2026-10-22: 3 回目のレビューは Critical 0 / Warning 1 / Info 2
  - Warning（名前だけの呼び出しは PATH の偽物に化け、devenv の相対パスの `node_modules/.bin` で実際に成り立つ）: devenv の PATH の先頭が `node_modules/.bin` であることを確かめた。ユーザーと相談し、読み取り系の allow をやめ、`tail -f` の prompt だけ残した
  - Info 1（よく使うリポジトリを Nix で `untrusted` と宣言する）: 直さない。プロジェクトの trust はユーザーが個別に管理するため
  - Info 2（`tail -f` の prompt が当たらない形をコメントにも書く）: `default.nix` のコメントに書いた
