---
description: Address the review comments on a pull request — fix them, reply to each thread, and resolve it. Use when a PR has received review feedback (from /autodev-review-pr or a human reviewer) and you want to address it.
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion, "Bash(git branch --show-current)", "Bash(git status *)", "Bash(git add *)", "Bash(git commit *)", "Bash(git push *)", "Bash(devenv shell lint-all)", "Bash(gh pr list *)", "Bash(gh pr view *)", "Bash(gh pr comment *)", "Bash(gh api graphql *)"
---

# レビューの取り込み

PR「$ARGUMENTS」のレビューを取り込む。

## 1. 指摘を集める

- `$ARGUMENTS` に番号か URL が無ければ、`gh pr list --head $(git branch --show-current) --json number --limit 1` で探す。
- 総評は `gh pr view <番号> --json reviews`、行コメントは次のスレッドの一覧で取る。`isResolved` が `false` のものが対象。`hasNextPage` が `true` なら見落とすので、止めてユーザーに伝える。

```bash
gh api graphql -F owner='{owner}' -F repo='{repo}' -F number=<番号> -f query='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        pageInfo { hasNextPage }
        nodes { id isResolved isOutdated path line originalLine comments(first: 20) { nodes { author { login } body } } }
      }
    }
  }
}' --jq '.data.repository.pullRequest.reviewThreads'
```

## 2. 仕分けて直す

- 直す: バグ、セキュリティ、規約との食い違い、妥当な改善。Critical と Warning は原則直す。
- 直さない: ユーザーが明示的に決めた設計、プロジェクトの方針と異なる提案、過剰な抽象化や将来への備え。
- 迷うもの(トレードオフや方針に関わるもの)だけ、まとめて AskUserQuestion で聞く。それ以外は聞かずに進める。

直したら `devenv shell lint-all` で確かめ、コミットしてプッシュする。

## 3. 返信して解決する

- 各スレッドに返信する。直したものは内容とコミット、直さないものは理由を書く。本文は標準入力から渡す。
- 返信したらスレッドを解決する。人間のレビュアーのスレッドで、相手の判断を待つべきもの(直さない判断など)は解決せずに残す。
- 総評の指摘のうち直さないものは、理由を `gh pr comment` で書く。

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

## 4. 報告

直した指摘、直さなかった指摘(理由つき)、残したスレッドをユーザーに伝える。
