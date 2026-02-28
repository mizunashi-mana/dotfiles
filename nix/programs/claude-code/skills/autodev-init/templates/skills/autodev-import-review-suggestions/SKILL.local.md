---
description: Import and apply local review comments interactively. Use when a local review has been completed and you want to address the suggestions.
allowed-tools: Read, Write, Edit, MultiEdit, Bash, Glob
---

# ローカルレビュー取り込み

PR「$ARGUMENTS」のローカルレビュー結果を確認し、対話的に修正を行います。

## 手順

1. **レビューファイルの特定**:
   - `$ARGUMENTS` が指定されている場合: その PR 番号を使用
   - `$ARGUMENTS` が空の場合:
     1. `git branch --show-current` で現在のブランチ名を取得
     2. `gh pr list --head <branch-name> --json number --limit 1` で該当ブランチの PR 番号を検索
   - `.ai-agent/tmp/reviews/` 配下から `*-pr-{PR番号}` に一致するディレクトリを探す
   - そのディレクトリ内の `REVIEW-{連番}.md` のうち、最大の連番のファイルを最新レビューとして読み込む

2. **各指摘事項の確認**:
   - レビューファイルの内容をパースし、Critical / Warning / Info の各指摘を一覧化
   - 各指摘について修正の要否を判断（推奨/不要/要確認）
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
> 指摘内容の要約

→ **修正推奨/不要/要確認**: 理由

---
```

最後に「まとめ: X件修正、Y件スキップでよいですか？」と確認する。
