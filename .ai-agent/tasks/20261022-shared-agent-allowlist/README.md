# Claude と Codex の許可リストをそろえる

## 目的

Codex の auto_review と Claude の確認で止まる回数を減らすため、よく使う安全なコマンド（`git fetch`・`gh pr list` など）を、Claude・Codex の双方で同じように許可する。

## 方針

- 基本チェックを通るコマンドを、Codex の `rules.allowed`（`read-only.rules` から名前を変えた）に `prefix_rule` で直接書く。Claude の許可リストには、もともとすべて入っている（`git fetch:*` など広い形で）ので変えない
- 共通のファイルから両方を作る形は採らない。二重に書くことになるが、それぞれの設定をそのまま読めるほうを取る
- 基本チェック
  - 消したり上書きしたりしない
  - 外へ公開しない（push・PR やコメントの作成・マージなどをしない）
  - 書き込みは手元のメタデータとキャッシュ（`refs/remotes` など）だけ
  - 止めない限り終わらないもの（`tail -f` など）ではない。`sleep` や `gh run watch` は長くかかっても終わるので入れる
- 入れるもの: これまでの Codex の読み取り系、git の読み取り系と `fetch origin` / `ls-remote origin` / `remote prune origin`、gh の読み取り系、`date` / `ps` などの情報を見るだけのコマンド
- 入れないもの（Claude だけに残す）: `cp` / `mv` / `sed` / `git add` / `git commit`（フックが走る）/ `gh run download`（`-D` で任意の場所に書ける）/ `brew info`（Ruby のファイルを評価できる）/ 相手を origin に固定しない `git fetch` などと、npm・aws・kubectl・nix 系など
- これまでどおり Codex に入れないもの: `rg`（`--pre` で任意の実行）/ `file`（`-C` で書き込み）/ `sort`・`tree`（`-o` で書き込み）/ `xxd`（`-r` で書き込み）/ `command` / `xargs`
- Codex では、決まった位置に来る gh の `-R` / `--repo` を `prompt` にする

### 判断メモ

- Codex では allow に当たったコマンドは review なしで sandbox の外で走る。#325 では、次の穴を理由に git / gh を入れなかった。ユーザーと相談し、受け入れることにした。どれも回りくどい手順（読んだ値を URL に組み込む、入れ子のリポジトリと設定を作るなど）を踏む必要があり、その途中のどこかで auto_review が止めるという見込み込みで受け入れる
  1. 引数で送り先を変えられる（`gh pr list -R evil.example/...`・`gh pr view <URL>`・`git fetch <URL>`）。読んだ値を URL に載せて送れる
  2. 入れ子のリポジトリの `.git/config`（`core.fsmonitor`・`diff.external` など）と `workdir` の組み合わせで、git から任意のコマンドを実行できる。`git fetch origin` などは ref を書き換えるので `reference-transaction` フックも走り、origin を手元のパスに向ければ `--upload-pack` も走る
  3. `git diff` / `git log` / `git show` の `--output=<path>` で任意の場所に書き込める
- `prefix_rule` は決まった位置の引数にしか当たらず、`--repo=x` のような `=` つきの形にも当たらない。`prompt` は穴を塞ぐものではなく、よくある形を review に回すだけのもの
- Codex の rules のファイルは `read-only.rules` から `allowed.rules` に名前を変えた。読み取り系だけではなくなったため
- Codex の rules は、複数のルールに当たったとき一番厳しい判定になる（`codex execpolicy check` で確かめた）

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] Pro・Air の darwin 設定がビルドでき、生成された Codex の `allowed.rules` に基本チェックを通るコマンドが入っている
- [x] `codex execpolicy check` で、`git fetch origin` / `gh pr list` は allow、`gh pr list -R x/y` は prompt、`git fetch --upload-pa=x .` / `git push` / `gh pr create` はマッチしない
- [x] レビューを取り込み CI が通った PR → https://github.com/mizunashi-mana/dotfiles/pull/326

## 作業ログ

- 2026-10-22: 開始。git / gh の穴を受け入れ、決まった位置の `-R` などは prompt にする方針をユーザーと決めた。穴を突くには回りくどい手順が要り、途中で auto_review が止めるという見込みもユーザーから聞いた
- 2026-10-22: 共通リストを作り、Claude・Codex の双方をそこから作るようにした。lint-all と Pro・Air のビルドが通った。生成された `allowed.rules` を `codex execpolicy check` で確かめ、`gh pr view 1 --repo=x/y`（`=` つき）と `-R` が 4 番目以降に来る形は allow のままであることも確かめた
- 2026-10-23: 1 回目のレビューは Critical 1 / Warning 1 / Info 4
  - Critical（`git fetch --upload-pa=<cmd> .` などで 1 コマンドで任意の実行）: git 2.56.0 で再現した。ユーザーと相談し、共通リストの `git fetch` / `git ls-remote` / `git remote prune` を相手が `origin` のものに絞り、広い形は Claude だけに戻した。効かない `--upload-pack` の prompt は消した
  - Warning（`structure.md` に新しいファイルが無い）: 足した
  - Info 1（`Bash(true)` などが `:*` つきになり少し広くなる）: 直さない。どちらも引数で害が出ないため
  - Info 2（`rg` / `file` などを入れない理由が消えた）: README に書いた
  - Info 3（`sleep` / `gh run watch` が「止まらない」と食い違う）: 基本チェックを「止めない限り終わらないものではない」と書き直した
  - Info 4（`reference-transaction` フック）: 受け入れたリスク 2 に書き足した
- 2026-10-23: 2 回目のレビューは Critical 0 / Warning 0 / Info 2
  - Info 1（`--output` は `git log` / `git show` でも効く）: 共通リストのコメントと README に書いた
  - Info 2（`git rebase --continue` の並び順）: 直した
- 2026-10-23: ユーザーの指示で、共通リスト（`agent-allowed-commands.nix`）から作る形をやめた。Codex の rules はベタ書きにし、Claude の設定は master のままに戻した（共通リストのコマンドはもともとすべて入っていた）
