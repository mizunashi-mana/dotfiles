---
description: Merge the current branch's PR once it is pushed, reviewed, and green, then switch back to master, pull, and delete the merged branch. Use when a PR is ready to merge, or already merged, and you want to start the next task from a fresh master.
disable-model-invocation: true
allowed-tools: Read, Glob, "Bash(git status *)", "Bash(git branch *)", "Bash(git rev-parse *)", "Bash(git switch *)", "Bash(git pull *)", "Bash(git fetch *)", "Bash(git ls-remote *)", "Bash(gh pr list *)", "Bash(gh pr view *)", "Bash(gh pr checks *)", "Bash(gh pr merge *)", "Bash(gh run list *)", "Bash(gh run view *)", "Bash(gh api graphql *)"
---

# マージして master に戻る

ユーザーが `/autodev-merge-and-switch` で呼んだことを、今のブランチの PR をマージしてよいという指示とみなし、マージの前にあらためて聞かない。聞かずにマージするので、モデルが自分では呼ばない（`disable-model-invocation`）。

## 1. 確認

- `git status` で未コミットの変更が無いかを確かめる。あれば切り替える前にユーザーに伝えて止める。
- `git branch --show-current` で今のブランチ名を控える。
- `gh pr list --head <ブランチ> --state all --json number,state,url --limit 1` で PR の状態を見る。
  - `OPEN`: 手順 2 でマージする。
  - `MERGED`: 手順 3 へ進む。手順 3 でローカルのブランチも消す。
  - `CLOSED`（マージせずに閉じた）、または PR が無い: マージせず手順 3 へ進む。ローカルのブランチは消さない。

## 2. マージ

次をすべて満たすかを確かめる。1 つでも満たさなければ、どれを満たさないかをユーザーに伝えて止める。

- プッシュ済み: `gh pr view <番号> --json isDraft,mergeable,headRefOid` の `headRefOid` が `git rev-parse HEAD` と同じ。
- 下書きでない: `isDraft` が `false`。
- 衝突が無い: `mergeable` が `MERGEABLE`。プッシュの直後は `UNKNOWN` のことがあるので、そのときは少し待って取り直す。
- レビュー済みで Critical が残っていない: 下の「レビューの確かめ方」で確かめる。最新のレビューが古いコミットに付いていても止めない。Warning と Info の取り込みはレビューの後に行い、Critical を直したときは `/autodev-start-task` がレビューをやり直すため。
- CI が落ちていない: `gh pr checks <番号>` に失敗が無い。実行中のものがあっても、ここでは止めない。

満たしていれば、CI が終わるまで待つ。Bash の `timeout` を上限の `600000`（10 分）にして走らせる。

```bash
gh pr checks <番号> --watch --interval 30
```

- 終了コードが 0 なら通っている。マージへ進む。
- 出力に `fail` の行があれば落ちている。`fail` のチェックと、その URL の `runs/<run の id>` について `gh run view <run の id> --log-failed` で見た原因をユーザーに伝えて止める。ここでは直さない。
- 時間切れで終わったら、もう 1 回走らせる。合わせて 30 分待っても終わらなければ、run とジョブの状態（`gh run list --commit <headRefOid>`、`gh run view <run の id> --json jobs`）を見て、見立てをユーザーに伝えて止める。run の再実行や取り消しはしない。
- `no checks reported` で終わったら、run がまだ登録されていない。`gh run list --commit <headRefOid> --json databaseId --jq length` が 1 以上になったら走らせ直す。4 回見ても 0 のままで、`.github/workflows/` も無ければ CI が無いとみなしてマージへ進む。workflow があるならユーザーに伝えて止める。

CI が通ったら、マージコミットでマージする。失敗したらエラーをユーザーに伝えて止める。

```bash
gh pr merge <番号> --merge
```

### レビューの確かめ方（GitHub レビュー）

- `gh pr view <番号> --json reviews,reviewDecision` で、`reviews` が 1 件以上あり、`reviewDecision` が `CHANGES_REQUESTED` でない。
- 本文に `推奨アクション:` を含むレビューのうち最新のもので、Critical が 0 件であり、推奨アクションが `REQUEST_CHANGES` でない。`/autodev-review-pr` は自分の PR に `COMMENT` しか付けられず、推奨アクションを本文に書くので、`reviewDecision` だけでは分からない。スレッドへの返信は本文が空のレビューとして `reviews` に並ぶので、単に最新のレビューを見ると返信を拾ってしまう。
- スレッドがすべて解決済み。次の一覧に `isResolved` が `false` のものが無い。残っていれば、どの指摘かが分かるように `path`・`line`（null なら `originalLine`）・最初のコメントを挙げて止める。`pageInfo.hasNextPage` が `true` なら 100 件を超えていて見落とすので、そのときも止める。返し忘れた指摘かもしれないので、自分では解決しない。

  ```bash
  gh api graphql -F owner='{owner}' -F repo='{repo}' -F number=<番号> -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        reviewThreads(first: 100) {
          pageInfo { hasNextPage }
          nodes { isResolved isOutdated path line originalLine comments(first: 1) { nodes { body } } }
        }
      }
    }
  }' --jq '.data.repository.pullRequest.reviewThreads | {hasNextPage: .pageInfo.hasNextPage, unresolved: [.nodes[] | select(.isResolved | not)]}'
  ```

### レビューの確かめ方（ローカルレビュー）

- `.ai-agent/tmp/reviews/*-pr-<番号>/` に `REVIEW-<連番>.md` が 1 件以上ある。
- 最新の REVIEW ファイル（日付が最も新しいディレクトリの中で連番が最も大きいもの）で、Critical が 0 件であり、推奨アクションが `REQUEST_CHANGES` でない。
- 指摘があるなら、その REVIEW ファイルに「対応結果」の節があり、すべての指摘に対応結果が書かれている。

## 3. 切り替え

```bash
git switch master
git pull --ff-only
git fetch --prune
```

- マージ済みのブランチはリモートで自動で消える前提なので、`fetch --prune` で追跡ブランチも消す。マージした後も `git ls-remote --heads origin <ブランチ>` でリモートのブランチが残っていれば、自動削除が無効なので、その旨をユーザーに伝える（自分では消さない）。

PR をマージしたとき、または `MERGED` だったときだけ、ローカルのブランチを消す。

```bash
git branch -d <ブランチ>
```

- `-d` が失敗したら、消さずにユーザーに伝える。`-D` で強制的に消さない。
- `-d` は、ブランチの upstream に取り込まれていれば master に取り込まれていなくても消してしまう。そのため、消してよいかは `-d` に任せず、PR の状態で決める。

## 4. 次へ

- `.ai-agent/projects/` のタスクだったなら、プロジェクトの README でタスクの状態を「完了」にするよう促す。
- 文脈が長くなっていれば `/clear` か `/compact` を勧める。
