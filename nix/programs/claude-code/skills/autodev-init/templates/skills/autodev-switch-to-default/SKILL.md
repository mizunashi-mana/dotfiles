---
description: Switch to the default branch after a PR is merged, pull latest changes, and run compaction. Use after merging or having a PR merged to start fresh.
allowed-tools: "Bash(git checkout *)", "Bash(git pull *)", "Bash(git pull)", "Bash(git branch *)", "Bash(git rev-parse *)", "Bash(git remote *)", "Bash(git symbolic-ref *)", "Bash(gh pr view *)", "Bash(gh pr merge *)", mcp__github__pull_request_read, mcp__github__merge_pull_request, mcp__github__list_pull_requests
---

# デフォルトブランチへの切り替え

PR のマージ後にデフォルトブランチへ切り替え、最新の変更を取り込み、compaction を実行して次の作業に備えます。

## 手順

### 1. PR のマージ状況を確認

現在のブランチに関連する PR があるかを確認する。

```bash
gh pr view --json state,mergedAt,url
```

- **PR がマージ済み**: 次のステップに進む
- **PR がオープン**: ユーザーに「この PR をマージしますか？」と確認し、承認を得てからマージする
  ```bash
  gh pr merge --merge
  ```
  マージ方法（merge / squash / rebase）はユーザーに確認する。
- **PR が存在しない**: そのまま次のステップに進む

### 2. デフォルトブランチの特定

```bash
git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
```

上記でデフォルトブランチ名（例: `main`, `master`）を取得する。

### 3. 現在のブランチを確認

```bash
git branch --show-current
```

既にデフォルトブランチにいる場合は、切り替えをスキップして pull に進む。

### 4. デフォルトブランチに切り替え

```bash
git checkout <デフォルトブランチ>
```

### 5. 最新の変更を取り込み

```bash
git pull
```

### 6. compaction の実行

ユーザーに「compaction を実行してよいですか？」と確認し、承認を得てから `/compact` を実行する。

## 注意事項

- 未コミットの変更がある場合は、切り替え前にユーザーに警告する
- pull に失敗した場合はエラー内容をユーザーに報告する
