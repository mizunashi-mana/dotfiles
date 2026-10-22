---
description: Triage a development request and carry it out on a new branch until its PR has been reviewed, the review findings are addressed, and CI passes. Use when beginning a feature, bug fix, or improvement; routes to autodev-start-survey or autodev-start-project when the request needs investigation first or spans multiple PRs.
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, "Bash(git status *)", "Bash(git fetch *)", "Bash(git switch *)", "Bash(git add *)", "Bash(git commit *)", "Bash(git diff *)", "Bash(git log *)", "Bash(git push *)", "Bash(git merge *)", "Bash(git rev-parse *)", "Bash(devenv shell lint-all)", "Bash(gh pr comment *)", "Bash(gh pr view *)", "Bash(gh pr checks *)", "Bash(gh run list *)", "Bash(gh run view *)", "Bash(gh api graphql *)", Skill(autodev-create-pr), Skill(autodev-review-pr), Skill(autodev-start-survey), Skill(autodev-start-project)
---

# タスクの開始

「$ARGUMENTS」を仕分けし、1 ブランチ・1 PR で進める。

**ゴールは、レビューを取り込み CI が通った PR を作ること。** PR を作った時点でもレビューを受けた時点でもなく、`/autodev-review-pr` の指摘をすべて直すか直さない理由を残し、最後のプッシュの CI が通り、ブランチに未コミット・未プッシュの変更が無い時点で完了とする。

ユーザーに確かめるのは、はっきりしない要件、仕分けの行き先、方針、方針に関わる指摘、自力で直せない CI の失敗だけにする。それ以外は聞かずに進める。

## 1. 仕分け

依頼を読み、行き先を決める。

| 状態                                   | 行き先                   | 例                             |
| -------------------------------------- | ------------------------ | ------------------------------ |
| やり方が分からない・比べてから決めたい | `/autodev-start-survey`  | 「CI を速くする方法を比べる」  |
| 複数の PR に分けないと進まない         | `/autodev-start-project` | 「認証を全面的に作り直す」     |
| ゴールと完了条件が書け、1 PR で収まる  | このまま続ける           | 「入力のバリデーションを足す」 |

- 何をしたいかがまだはっきりしないときは、行き先を決める前に AskUserQuestion で聞いて、ゴールと完了条件を固める。
- 別のスキルに回すときは、理由と行き先をユーザーに示し、同意を得てから切り替える。

## 2. 下調べ

- `.ai-agent/steering/`（`tech.md`・`plan.md`・`work.md` など）と `.ai-agent/structure.md` のうち、関係するものを読む。
- 触るコードと、その周りの既存の書き方を確かめる。
- `.ai-agent/projects/` のタスクなら、プロジェクトの README で依存タスクが終わっているかを確かめ、状態を「進行中」にする。

## 3. 方針の確認

次をユーザーに示し、確認を取る。

- 目的
- 方針（何をどう変えるか）
- 完了条件（確かめ方を含む）
- ブランチ名（`work.md` の規約どおり `<type>/<kebab-case>`）

確認が取れたら、`.ai-agent/tasks/YYYYMMDD-<kebab-case>/README.md` に書く。

```markdown
# <タスク名>

プロジェクト: <.ai-agent/projects/ の README へのリンク。無ければ省く>

## 目的

## 方針

## 完了条件

- [ ] ...
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- YYYY-MM-DD: 開始
```

- 途中で方針が変わったら README を直し、作業ログに理由を残す。文脈が切れても README から再開できるようにする。

## 4. 実装

1. `git status` で未コミットの変更が無いことを確かめる。あれば前のタスクのものかもしれないので、ユーザーに伝えて止める。
2. `git fetch origin` の後、`git switch --no-track -c <ブランチ名> origin/master` でブランチを作る。今居るブランチから切ると前のタスクのまだマージされていないコミットが入るため、必ず `origin/master` を起点にする。
3. TodoWrite で作業を分け、1 つずつ進める。
4. 区切りごとに `devenv shell lint-all` で確かめる。Nix の変更は、関係するホストの設定がビルドできるかも確かめる。
5. 意味のまとまりでコミットする。

## 5. PR とレビュー

1. 完了条件を満たしているか確かめる。満たせなかったものは隠さずに挙げる。README の完了条件と作業ログを更新し、実装とまとめてコミットする。
2. `/autodev-create-pr` で PR を作る。
3. `/autodev-review-pr <番号>` でレビューする。
4. 指摘を取り込む。
   - Critical と Warning は直す。Info は妥当なものを直す。
   - 直すか迷うもの（方針に関わるもの、トレードオフがあるもの）は AskUserQuestion で聞く。
   - 直したら確かめ直し、コミットしてプッシュする。PR の本文とずれたら `/autodev-create-pr` で本文を更新する。
   - 下の「対応結果を残す」で、指摘ごとに直した内容か直さない理由を残す。
5. Critical を直したときは `/autodev-review-pr` をもう一度走らせ、新しい Critical が無いことを確かめる。2 回目でも Critical が残るときは、止めてユーザーに相談する。
6. README の最後の完了条件に PR の URL を書いてチェックし、作業ログに取り込んだ指摘と取り込まなかった指摘（理由つき）を残す。コミットしてプッシュし、`git status` でブランチがきれいなことを確かめる。CI を待つ前にチェックを付けるのは、待った後に README だけのコミットを足して CI をもう一度走らせないため。CI が落ちたら手順 7 で直し、作業ログに残す。
7. 下の「CI を待つ」で、最後のプッシュの CI が通るまで待つ。
8. PR の URL、確かめた結果（CI の結果を含む）、取り込んだ指摘と取り込まなかった指摘をユーザーに報告する。

## 対応結果を残す（GitHub レビュー）

- 行コメントの指摘には、そのスレッドに返信する。直したものは直した内容とコミットを、直さないものは理由を書く。返信したらスレッドを解決する。ユーザーに聞いている指摘のスレッドは、答えが出るまで解決しない。
- 総評にまとめられた Info のうち直さないものは、理由を PR のコメント（`gh pr comment`）に書く。
- 手順 6 の前にスレッドの一覧を取り直し、`isResolved` が `false` のスレッドが無いことを確かめる。残っていれば返し忘れなので返信して解決する。

スレッドの一覧は次で取る。`pageInfo.hasNextPage` が `true` なら 100 件を超えていて見落とすので、止めてユーザーに伝える。直してコードが変わったスレッドは `line` が null になるので、`originalLine` で場所を見る。

```bash
gh api graphql -F owner='{owner}' -F repo='{repo}' -F number=<番号> -f query='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        pageInfo { hasNextPage }
        nodes { id isResolved isOutdated path line originalLine comments(first: 1) { nodes { body } } }
      }
    }
  }
}' --jq '.data.repository.pullRequest.reviewThreads'
```

返信と解決は次のとおり。返信の本文は、引用符や改行で壊れないように標準入力から渡す。

```bash
gh api graphql -F id=<スレッドの id> -F body=@- -f query='
mutation($id: ID!, $body: String!) {
  addPullRequestReviewThreadReply(input: { pullRequestReviewThreadId: $id, body: $body }) { comment { url } }
}' <<'BODY'
<返信>
BODY
gh api graphql -F id=<スレッドの id> -f query='
mutation($id: ID!) { resolveReviewThread(input: { threadId: $id }) { thread { isResolved } } }'
```

## 対応結果を残す（ローカルレビュー）

`/autodev-review-pr` が返したレビューファイル（`.ai-agent/tmp/reviews/...`）の末尾に、指摘ごとの対応結果を追記する。`.ai-agent/tmp/` は git 管理外なのでコミットしない。

```markdown
## 対応結果

- **1. path:line**: 修正済み — 何をどう直したか（コミット）
- **2. path:line**: 直さない — 理由
```

## CI を待つ

CI が終わる前に報告しない。ローカルで通っていても、CI だけで落ちることがある。

1. CI が終わるまで待つ。Bash の `timeout` を上限の `600000`（10 分）にして走らせる。

   ```bash
   gh pr checks <番号> --watch --interval 30
   ```

   - 終了コードが 0 なら通っている。
   - 時間切れで終わったら、もう 1 回走らせる。合わせて 30 分待っても終わらなければ、下の「CI が終わらないとき」で調べる。
   - 出力に `fail` の行があれば落ちている。2 へ進む。
   - `no checks reported` で終わったら、run がまだ登録されていない（プッシュの直後に起きる）。`gh run list --commit "$(git rev-parse HEAD)" --json databaseId --jq length` で run の件数を見て、1 以上になったら走らせ直す。4 回見ても 0 のままで、`.github/workflows/` も無ければ CI が無いとみなし、作業ログに書いて終える。workflow があるなら「CI が終わらないとき」で調べる。
   - それ以外で 0 以外の終了コードなら API のエラーなので、走らせ直す。

2. 落ちたら直す。`fail` のチェックの URL の `runs/<run の id>` について `gh run view <run の id> --log-failed` でログを見る。ローカルで再現させて直し、確かめ直す。README の作業ログに落ちた理由と直し方を足し、修正とまとめてコミットしてプッシュし、1 からやり直す。ローカルで再現しない、または直し方が方針に関わるときは、ユーザーに聞く。

### CI が終わらないとき

原因を調べ、見立てをユーザーに伝えて止める（衝突だけは直してよい）。run の再実行（`gh run rerun`）や取り消し（`gh run cancel`）は、見立てを伝えてユーザーに確かめてから行う。

1. `gh pr view <番号> --json mergeable,headRefOid` で PR の状態を見る。
   - `mergeable` が `CONFLICTING`: master と衝突していると `pull_request` の workflow は起動しない。`git merge origin/master` で取り込んで衝突を解き、確かめ直してプッシュし、「CI を待つ」の 1 からやり直す。
   - `headRefOid` が `git rev-parse HEAD` と違う: プッシュが届いていない。
2. 最後のコミットの run と、終わっていないジョブ・ステップを見る。

   ```bash
   gh run list --commit "$(git rev-parse HEAD)" --json databaseId,name,status,conclusion,createdAt
   gh run view <run の id> --json jobs --jq '.jobs[] | select(.status != "completed") | {name, status, startedAt, steps: [.steps[] | select(.status != "completed") | .name]}'
   ```

3. 見立てる。
   - run が無い、またはジョブが無いまま `failure` で終わっている: workflow の YAML の書き誤りか、Actions が止められている。
   - ジョブが `queued` のまま: ランナーが割り当てられていない。`gh run list --status queued` でほかの run も詰まっていないか、[GitHub の障害情報](https://www.githubstatus.com) を見る。
   - ジョブが `in_progress` で同じステップから進まない: そのステップ（サービスの起動待ち、テストのハングなど）を疑う。
