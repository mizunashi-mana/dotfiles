---
description: Replan the steering plan roadmap by reviewing completed work and open issues. Use when the plan.md roadmap has become outdated or after completing significant milestones.
allowed-tools: Read, Write, Edit, MultiEdit, Bash(mkdir *), Glob, Grep, AskUserQuestion, mcp__github__list_issues, mcp__github__search_issues
---

# ロードマップ再策定

steering plan ドキュメントのロードマップを再策定します。完了済みタスクの整理・今後の計画立案を、ユーザーとの対話を通じて行います。

## 対象ドキュメント

| ファイル                     | 役割                                   |
| ---------------------------- | -------------------------------------- |
| `.ai-agent/steering/plan.md` | 実装計画・ロードマップ（主な更新対象） |

## 手順

### 1. 現状把握

プロジェクトの実装状態を確認する:

- `ls nix/programs/` でプログラムモジュール一覧を確認
- `ls nix/hosts/` でホスト一覧を確認
- `ls .claude/skills/` でインストール済みスキルを確認
- `cat flake.nix` で flake inputs と構成を確認
- `.ai-agent/tasks/` と `.ai-agent/projects/` の状況を確認

### 2. 完了タスクの整理

既存の plan.md を読み込み、完了状態を特定する:

- plan.md の各マイルストーン・タスクについて、コードベースの実態と照合
- 実装済みの機能・タスクをリストアップ
- 部分的に完了しているものも把握

### 3. GitHub Issue 確認

オープンな Issue を確認し、未対応の課題を把握:

- `mcp__github__list_issues` でオープンイシューを取得
- 既存のロードマップに含まれていない Issue を特定
- Issue のラベルや優先度から分類

### 4. 現状報告

ユーザーに以下の形式で報告:

```
## ロードマップ現状

### 完了済み
| タスク/マイルストーン | 根拠 |
|---------------------|------|
| ...                 | ...  |

### 進行中
| タスク/マイルストーン | 状態 |
|---------------------|------|
| ...                 | ...  |

### 未着手（plan.md 記載）
| タスク/マイルストーン | 備考 |
|---------------------|------|
| ...                 | ...  |

### 新たに浮上した課題（GitHub Issue 等）
| Issue/課題 | 概要 |
|-----------|------|
| ...       | ...  |
```

### 5. ロードマップ再策定

ユーザーとの対話を通じて、今後のロードマップを策定する:

- **一方的に計画を提示しない**: 方向性・優先順位をユーザーに確認しながら進める
- 以下の点を対話的に決定:
  - 完了済みタスクの plan.md からの削除
  - 既存タスクの優先順位の見直し
  - 新たなタスク・マイルストーンの追加
  - フェーズ構成の見直し（必要に応じて）

### 6. ユーザー確認

再策定したロードマップの最終確認:

- plan.md の更新内容（差分）を提示
- ユーザーの承認を得てからドキュメントを更新

### 7. 修正実行

承認後、plan.md を更新:

- 完了済みタスクを削除または完了セクションに移動
- 新しいロードマップを反映
- フェーズや優先順位を更新

### 8. PR を作成する

- `/autodev-create-pr` を使用する

## 注意事項

- `autodev-steering` との違い: steering は事実関係の最新化、replan はロードマップの戦略的見直し
- plan.md が存在しない場合は、ユーザーに新規作成するか確認する
- 推測で計画を追加しない。ユーザーとの対話を通じて決定する
- 他の steering ドキュメント（product.md、tech.md 等）の更新が必要な場合は、`autodev-steering` スキルの利用を案内する
