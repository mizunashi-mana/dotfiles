---
description: Do tasks and build product by a specification
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Update, WebSearch, WebFetch
---

# 実装

機能の実装を開始: **$ARGUMENTS**

## インタラクティブ承認: タスクレビュー

**重要**: 実装はタスクがレビューおよび承認された後にのみ開始できます。

### タスクレビュープロセス

- 要件文書: @spec/specs/$ARGUMENTS/requirements.md
- 設計文書: @spec/specs/$ARGUMENTS/design.md
- タスク文書: @spec/specs/$ARGUMENTS/tasks.md
- 仕様メタデータ: @spec/specs/$ARGUMENTS/spec.json

**インタラクティブ承認プロセス**:

1. **文書が存在するか確認** - requirements.mdとdesign.md、tasks.mdが生成されていることを確認
2. **要件レビューをプロンプト** - ユーザーに確認: "requirements.mdをレビューしましたか？ [y/N]"
3. **設計レビューをプロンプト** - ユーザーに確認: "design.mdをレビューしましたか？ [y/N]"
4. **設計レビューをプロンプト** - ユーザーに確認: "tasks.mdをレビューしましたか？ [y/N]"
5. **全て'y'（はい）の場合**: spec.jsonを自動的に更新して両方のフェーズを承認し、実装を続行
6. **いずれかが'N'（いいえ）の場合**: 実行を停止し、該当する文書を最初にレビューするようユーザーに指示

**ユーザーがレビューを確認したときのspec.jsonの自動承認更新**:

```json
{
  "approvals": {
    "requirements": {
      "generated": true,
      "approved": true // ← ユーザーが確認したとき自動的にtrueに設定
    },
    "design": {
      "generated": true,
      "approved": true // ← ユーザーが確認したとき自動的にtrueに設定
    },
    "tasks": {
      "generated": true,
      "approved": true // ← ユーザーが確認したとき自動的にtrueに設定
    }
  },
  "phase": "implementing",
  "ready_for_implementation": true
}
```

**ユーザーインタラクションの例**:

```
📋 実装前に要件と設計、タスクのレビューが必要です。
📄 レビューしてください: spec/specs/feature-name/requirements.md
❓ requirements.mdをレビューしましたか？ [y/N]: y
📄 レビューしてください: spec/specs/feature-name/design.md
❓ design.mdをレビューしましたか？ [y/N]: y
📄 レビューしてください: spec/specs/feature-name/tasks.md
❓ tasks.mdをレビューしましたか？ [y/N]: y
✅ 要件と設計、タスクを自動的に承認しました。実装を続行します...
```

## コンテキスト分析

### タスクの順序

タスク文書の上から実行していきます。

- 既にチェックがついているタスクは実行済みです。チェックがついていない中で、一番上のタスクから実行しましょう。
- もし、後続の作業で、前に実行したタスクの内容を修正した方が良いことが分かった時は、新たにタスクを追加してください。

### タスクの完遂

タスクが終了したら、タスク文書にチェックマークを入れ、ユーザに実装結果を確認してもらいましょう。
