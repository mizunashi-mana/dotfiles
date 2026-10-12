---
description: Merge the current branch's PR once it is pushed, reviewed, and green, then switch back to master and pull. Use when a PR is ready to merge, or already merged, and you want to start the next task from a fresh master.
disable-model-invocation: true
allowed-tools: "Bash(git status *)", "Bash(git branch *)", "Bash(git rev-parse *)", "Bash(git switch *)", "Bash(git pull *)", "Bash(git fetch *)", "Bash(gh pr list *)", "Bash(gh pr view *)", "Bash(gh pr checks *)", "Bash(gh pr merge *)", "Bash(gh run view *)", "Bash(gh api graphql *)"
---

# マージして master に戻る

ユーザーが `/autodev-switch-to-default` で呼んだことを、今のブランチの PR をマージしてよいという指示とみなし、あらためて聞かない。聞かずにマージするので、モデルが自分では呼ばない(`disable-model-invocation`)。

## 1. 確認

- `git status` で未コミットの変更が無いかを確かめる。あればユーザーに伝えて止める。
- `git branch --show-current` でブランチ名を控える。`master` なら手順 3 へ。
- `gh pr list --head <ブランチ> --state all --json number,state,url --limit 1` で PR の状態を見る。
  - `OPEN`: 手順 2 でマージする。
  - `MERGED`: 手順 3 へ。ローカルのブランチも消す。
  - `CLOSED`、または PR が無い: マージせず手順 3 へ。ローカルのブランチは消さない。

## 2. マージ

`gh pr view <番号> --json isDraft,mergeable,headRefOid,reviews` とスレッドの一覧で、次をすべて満たすかを確かめる。1 つでも満たさなければ、どれかをユーザーに伝えて止める。

- プッシュ済み: `git rev-parse HEAD` が `headRefOid` と同じ。
- レビュー済み: `reviews` が 1 件以上あり、最新のレビューに Critical が残っていない(推奨アクションが `REQUEST_CHANGES` でない)。自分の PR には `COMMENT` しか付けられないので、本文の推奨アクションで判断する。
- スレッドがすべて解決済み。残っていれば `path`・`line`(null なら `originalLine`)・最初のコメントを挙げて止める。返し忘れかもしれないので、自分では解決しない。

  ```bash
  gh api graphql -F owner='{owner}' -F repo='{repo}' -F number=<番号> -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        reviewThreads(first: 100) {
          pageInfo { hasNextPage }
          nodes { isResolved path line originalLine comments(first: 1) { nodes { body } } }
        }
      }
    }
  }' --jq '.data.repository.pullRequest.reviewThreads | {hasNextPage: .pageInfo.hasNextPage, unresolved: [.nodes[] | select(.isResolved | not)]}'
  ```

- 下書きでない、衝突が無い(`mergeable` が `MERGEABLE`。`UNKNOWN` なら少し置いて取り直す)。

満たしていれば、Bash の `timeout` を `600000` にして CI を待つ。

```bash
gh pr checks <番号> --watch --interval 30
```

- 通ったら `gh pr merge <番号> --merge` でマージする。失敗したらエラーを伝えて止める。
- 落ちたら、`gh run view <run の id> --log-failed` で見た原因を伝えて止める。ここでは直さない。

## 3. 切り替え

```bash
git switch master
git pull --ff-only
git fetch --prune
```

PR をマージしたとき、または `MERGED` だったときだけ、`git branch -d <ブランチ>` でローカルのブランチを消す。失敗しても `-D` で強制せず、ユーザーに伝える。

## 4. 次へ

- `.ai-agent/projects/` のタスクだったなら、プロジェクトの README の状態を「完了」にするよう促す。
- 文脈が長くなっていれば `/clear` か `/compact` を勧める。
