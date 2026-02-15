---
description: Review a GitHub pull request with structured code review. Use when you want to check code quality, find bugs, and post review comments on a PR.
allowed-tools: Read, Glob, Grep, mcp__github__pull_request_read, mcp__github__pull_request_review_write, mcp__github__add_comment_to_pending_review, mcp__github__get_file_contents, mcp__github__list_pull_requests
---

# PR レビュー

PR「$ARGUMENTS」のコードをレビューし、GitHub の Review 機能でコメントを投稿します。

## 手順

1. **対象 PR の特定**:
   - `$ARGUMENTS` が指定されている場合: その PR 番号または URL を使用
   - `$ARGUMENTS` が空の場合:
     1. `git branch --show-current` で現在のブランチ名を取得
     2. `gh pr list --head <branch-name> --json number,url --limit 1` で該当ブランチの PR を検索
     3. PR が見つかった場合はその PR をレビュー対象とする
     4. PR が見つからない場合はユーザーに PR 番号の指定を求める

2. **Steering ドキュメントの確認**:
   - `.ai-agent/steering/tech.md` で技術スタック・コーディング規約を確認
   - `.ai-agent/steering/plan.md` で実装計画・方針を確認
   - `.ai-agent/structure.md` でディレクトリ構成・アーキテクチャを確認
   - 変更内容が関連する場合は `.ai-agent/steering/product.md` も参照

3. **PR 情報の取得**:
   - `mcp__github__pull_request_read` で PR の基本情報を取得（method: `get`）
   - タイトル、説明、ベースブランチを確認

4. **変更ファイルの取得**:
   - `mcp__github__pull_request_read` で変更ファイル一覧を取得（method: `get_files`）
   - `mcp__github__pull_request_read` で差分を取得（method: `get_diff`）

5. **コードレビュー実施**:
   - 各変更ファイルを確認
   - 以下の観点でレビュー:
     - バグ・ロジックエラー
     - セキュリティ問題（インジェクション、認証、認可）
     - パフォーマンス問題
     - 可読性・保守性
     - 命名規則・コーディング規約（tech.md 準拠）
     - アーキテクチャ整合性（structure.md 準拠）
     - エラーハンドリング
     - テストの妥当性

6. **Pending Review の作成**:
   - `mcp__github__pull_request_review_write` で pending review を作成（method: `create`）
   - event は指定せず、まず pending 状態で作成

7. **行コメントの追加**:
   - `mcp__github__add_comment_to_pending_review` で各コメントを追加
   - 適切な行番号と side (LEFT/RIGHT) を指定
   - subjectType: LINE で行レベルのコメント
   - Critical/Warning の指摘がある場合のみ行コメントを追加

8. **Submit**:
   - レビュー結果に基づいてアクションを決定:
     - Critical がある場合: REQUEST_CHANGES
     - Critical がなく Warning のみ、または Info のみ: COMMENT
     - 問題がない場合: APPROVE（自分の PR の場合は COMMENT にフォールバック）
   - `mcp__github__pull_request_review_write` で submit（method: `submit_pending`）
   - body に総評を含める

9. **レビュー結果の報告**:
   - 投稿完了後、ユーザーにレビュー結果のサマリーを報告

## レビュー観点

### Critical（修正必須）

- セキュリティ脆弱性（XSS、SQLi、コマンドインジェクション等）
- データ損失のリスク
- 明らかなバグ・クラッシュの原因

### Warning（修正推奨）

- パフォーマンス問題
- エラーハンドリングの不足
- 将来の保守性に影響する設計
- プロジェクト方針・アーキテクチャとの不整合
- tech.md のコーディング規約違反

### Info（提案）

- コードスタイル・可読性の改善
- より良い実装パターンの提案
- ドキュメント・コメントの追加

## 出力フォーマット

```
## レビュー結果

### Critical (X件)

**1. ファイル名:行番号**
> コードスニペット

問題: 具体的な問題の説明
修正案: 改善提案

---

### Warning (Y件)
...

### Info (Z件)
...

---

**総評**: 全体的な評価と次のステップ
**推奨アクション**: APPROVE / REQUEST_CHANGES / COMMENT
```

## 注意事項

- **Steering ドキュメントを必ず参照**: プロジェクト固有の方針・規約に基づいたレビューを行う
- ローカルにチェックアウトされていないファイルは `mcp__github__get_file_contents` で取得
- 大きな PR の場合はファイルごとに段階的にレビュー
- 技術的に正確な指摘を心がける
- 主観的な好みではなく、客観的な問題点を指摘
- 良い点も適切に褒める
