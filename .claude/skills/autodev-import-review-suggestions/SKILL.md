---
description: Import and apply PR review comments interactively. Use when a pull request has received review feedback and you want to address the suggestions.
allowed-tools: Read, Write, Edit, MultiEdit, mcp__github__pull_request_read
---

# PR レビュー取り込み

PR「$ARGUMENTS」のレビューコメントを確認し、対話的に修正を行います。

## 手順

1. **レビューコメント取得**:
   - `mcp__github__pull_request_read` で `get_review_comments` を実行
   - 未解決のコメントを一覧化

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
