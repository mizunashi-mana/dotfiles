---
description: Import and apply PR review comments interactively. Use when a pull request has received review feedback and you want to address the suggestions.
allowed-tools: Read, Write, Edit, MultiEdit, "Bash(gh pr view *)", "Bash(gh api *)", "Bash(git add *)", "Bash(git commit *)", "Bash(git push *)"
---

# PR レビュー取り込み

PR「$ARGUMENTS」のレビューコメントを確認し、対話的に修正を行います。

## 手順

1. **レビューコメント取得**:
   - `gh api --paginate "repos/{owner}/{repo}/pulls/<PR番号>/comments"` でレビューコメント本体を取得（`{owner}/{repo}` は `gh api` が現在のリモートから自動解決する）
   - 未解決のスレッドは GraphQL `pullRequest.reviewThreads(...){isResolved}` で判定する:

     ```bash
     gh api graphql -f query='query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){reviewThreads(first:100){nodes{isResolved comments(first:50){nodes{id databaseId path line body author{login}}}}}}}}' \
       -F owner=<owner> -F repo=<repo> -F pr=<PR番号>
     ```

     - `isResolved: false` のスレッドを未解決として扱う

   - 各コメントの REST `id`（= 返信用 commentId、GraphQL では `databaseId`）を記録

2. **各コメントの確認**:
   - コメント内容を要約してユーザーに提示
   - 修正の要否を判断（推奨/不要/要確認）
   - 理由を簡潔に説明

3. **ユーザーに確認**:
   - 修正する項目をまとめて提示
   - ユーザーの承認を得る

4. **修正実行**:
   - 承認された項目のみ修正
   - 各ファイルを編集

5. **コミット・プッシュ**:
   - 修正内容をまとめてコミット
   - PR ブランチにプッシュ

6. **レビューコメントへの返信**:
   - 各レビューコメントに対応結果を返信する
   - `gh api -X POST "repos/{owner}/{repo}/pulls/<PR番号>/comments/<commentId>/replies" -f body="<返信内容>"` で返信:
     - `<commentId>` は手順 1 で記録したコメントの REST ID
     - 改行を含む長い本文は `--input -` でヒアドキュメント JSON を渡す:
       ```bash
       gh api -X POST "repos/{owner}/{repo}/pulls/<PR番号>/comments/<commentId>/replies" --input - <<'JSON'
       { "body": "ありがとうございます。ご指摘の通り修正しました。..." }
       JSON
       ```
   - 修正した項目: 修正内容を簡潔に説明（例: 「修正しました。○○に変更しています。」）
   - スキップした項目: スキップの理由を説明（例: 「プロジェクト方針として○○のため、現状維持とします。」）
   - 返信はレビュワーへの感謝と具体的な対応内容を含める

## 判断基準

### 修正推奨

- バグ修正
- セキュリティ改善
- アクセシビリティ改善
- 明らかな UX 改善
- テストカバレッジの拡充

### 修正不要（スキップ）

- ユーザーが明示的に決定した設計
- プロジェクト方針と異なる提案
- 過剰な抽象化・将来対応の提案

### 要確認

- トレードオフがある変更
- 設計判断が必要な変更

## 出力形式

```
**1. ファイル名:行番号 - 概要**
> コメント要約

→ **修正推奨/不要/要確認**: 理由

---
```

最後に「まとめ: X件修正、Y件スキップでよいですか？」と確認する。

## 返信の例

- 修正した場合: 「ありがとうございます。ご指摘の通り修正しました。○○を△△に変更しています。」
- スキップした場合: 「ご提案ありがとうございます。検討しましたが、○○の理由から現状の実装を維持します。」
- 部分的に対応した場合: 「ありがとうございます。○○の部分は修正しました。△△については□□の理由から現状維持としています。」
