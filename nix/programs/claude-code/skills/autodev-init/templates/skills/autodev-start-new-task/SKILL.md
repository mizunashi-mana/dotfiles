---
description: Start a new implementation task with branch, README, and structured workflow. Use when beginning a feature, bug fix, or improvement that takes a day to a few days.
allowed-tools: Read, Write, Edit, MultiEdit, Update, WebSearch, WebFetch
---

# 新規タスク開始

新しいタスク「$ARGUMENTS」を開始します。

## 手順

1. **タスク名の決定**:
   - `$ARGUMENTS` の内容から適切なタスク名（英語、kebab-case）を考える
   - 簡潔で内容が分かるタスク名にする

2. **タスクディレクトリ作成**: `.ai-agent/tasks/YYYYMMDD-{タスク名}/README.md` を作成（YYYYMMDD は今日の日付）

3. **README.md に以下を記載**:
   - 目的・ゴール
   - 実装方針
   - 完了条件
   - 作業ログ（空欄で開始）

4. **関連ドキュメント確認**:
   - `.ai-agent/steering/plan.md` で該当フェーズを確認
   - `.ai-agent/steering/tech.md` で技術スタックを確認
   - `.ai-agent/structure.md` でディレクトリ構成を確認

5. **ユーザーに方針を提示して確認を取る**

6. **ブランチ作成**（ユーザー確認後）:
   - `git checkout -b {タスク名}` でブランチを作成
   - そのままブランチ作成することで、タスク内容を引き継ぐ。main の pull は後で良い

7. **TodoWrite でタスクを細分化**

8. **実装開始**

## 実装中の注意

- 各ステップで動作確認を行う
- 必要に応じてユーザーにフィードバックをもらう

## 完了時

- 完了条件をチェック
- 作業ログに結果を記載
- ユーザーに完了報告
- PR 作成は `/autodev:create-pr` を使用する
