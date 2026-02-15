---
description: Create a GitHub pull request from the current branch's changes. Use when changes are ready for review and you want to open a PR.
allowed-tools: Read, Glob, mcp__github__create_pull_request
---

# PR 作成

現在のブランチの変更内容から PR を作成します。

## 手順

1. **現在の状態を確認**:
   - `git status` で未コミットの変更がないか確認
   - `git log master..HEAD --oneline` で master からのコミット一覧を確認
   - `git diff master...HEAD --stat` で変更ファイルを確認

2. **リモートにプッシュ**:
   - ブランチがリモートにない場合は `git push -u origin <branch>` でプッシュ

3. **PR テンプレートを確認**:
   - `.github/PULL_REQUEST_TEMPLATE.md` を読み込む

4. **PR を作成**:
   - `mcp__github__create_pull_request` を使用
   - base ブランチ: `master`
   - タイトル: 変更内容を簡潔に要約
   - ボディ: PR テンプレートに沿って記載
     - 目的: 変更の背景・目的
     - 変更概要: 主な変更点を箇条書き
   - 注意点：改行のエスケープは不要。PR 説明の改行がエスケープされていないか確認する

5. **PR URL を報告**:
   - 作成した PR の URL をユーザーに伝える

## PR ボディのフォーマット

```markdown
## 目的

<!-- 変更の背景・目的を記載 -->

## 変更概要

<!-- 主な変更点を箇条書きで記載 -->

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## 注意事項

- コミットが済んでいない変更がある場合は、先にコミットするか確認する
- master ブランチへの直接プッシュは避ける
- PR タイトルは日本語で簡潔に（50文字以内推奨）
