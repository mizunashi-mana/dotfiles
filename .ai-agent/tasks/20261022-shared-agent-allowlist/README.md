# Claude と Codex の許可リストを共通にする

## 目的

Codex の auto_review と Claude の確認で止まる回数を減らすため、よく使う安全なコマンド（`git fetch`・`gh pr list` など）を、Claude・Codex の双方で同じように許可する。

## 方針

- 共通の許可リスト `nix/programs/agent-allowed-commands.nix`（単語の並びのリスト）を置き、Claude の `Bash(<words>:*)` と Codex の `prefix_rule(..., decision = "allow")` をそこから作る
- 共通リストに入れる基本チェック
  - 消したり上書きしたりしない
  - 外へ公開しない（push・PR やコメントの作成・マージなどをしない）
  - 書き込みは手元のメタデータとキャッシュ（`refs/remotes` など）だけ
  - 終わらずにセッションが止まらない
- 入れるもの: これまでの Codex の読み取り系、git の読み取り系と `fetch` / `remote prune`、gh の読み取り系、`date` / `ps` などの情報を見るだけのコマンド
- 入れないもの（Claude だけに残す）: `cp` / `mv` / `sed` / `git add` / `git commit`（フックが走る）/ `gh run download`（`-D` で任意の場所に書ける）/ `brew info`（Ruby のファイルを評価できる）/ npm・aws・kubectl・nix 系など
- Codex では、決まった位置に来る危ない引数だけ `prompt` にする: gh の `-R` / `--repo`、`git fetch` / `git ls-remote` の `--upload-pack`

### 判断メモ

- Codex では allow に当たったコマンドは review なしで sandbox の外で走る。#325 では、次の穴を理由に git / gh を入れなかった。ユーザーと相談し、受け入れることにした。どれも回りくどい手順（読んだ値を URL に組み込む、入れ子のリポジトリと設定を作るなど）を踏む必要があり、その途中のどこかで auto_review が止めるという見込み込みで受け入れる
  1. 引数で送り先を変えられる（`gh pr list -R evil.example/...`・`gh pr view <URL>`・`git fetch <URL>`）。読んだ値を URL に載せて送れる
  2. 入れ子のリポジトリの `.git/config`（`core.fsmonitor`・`diff.external` など）と `workdir` の組み合わせで、git から任意のコマンドを実行できる
  3. `git diff --output=<path>` などで任意の場所に書き込める
- `prefix_rule` は決まった位置の引数にしか当たらず、`--repo=x` のような `=` つきの形にも当たらない。`prompt` は穴を塞ぐものではなく、よくある形を review に回すだけのもの
- Codex の rules のファイルは `read-only.rules` から `allowed.rules` に名前を変えた。読み取り系だけではなくなったため
- Codex の rules は、複数のルールに当たったとき一番厳しい判定になる（`codex execpolicy check` で確かめた）

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] Pro・Air の darwin 設定がビルドでき、生成された Claude の `settings.json` と Codex の rules に共通リストが入っている
- [x] `codex execpolicy check` で、`git fetch origin` / `gh pr list` は allow、`gh pr list -R x/y` / `git fetch --upload-pack x` は prompt、`git push` / `gh pr create` はマッチしない
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-10-22: 開始。git / gh の穴を受け入れ、決まった位置の `-R` などは prompt にする方針をユーザーと決めた。穴を突くには回りくどい手順が要り、途中で auto_review が止めるという見込みもユーザーから聞いた
- 2026-10-22: 共通リストを作り、Claude・Codex の双方をそこから作るようにした。lint-all と Pro・Air のビルドが通った。生成された `allowed.rules` を `codex execpolicy check` で確かめ、`gh pr view 1 --repo=x/y`（`=` つき）と `-R` が 4 番目以降に来る形は allow のままであることも確かめた
