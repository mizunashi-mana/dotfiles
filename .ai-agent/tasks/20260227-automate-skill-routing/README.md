# スキル選択のルーティング自動化

GitHub Issue: https://github.com/mizunashi-mana/dotfiles/issues/186

## 目的・ゴール

`/autodev-start-new-task` に渡されたタスクの規模や性質を判断し、適切なスキルへのルーティングを提案する仕組みを導入する。これにより、人間がスキルの使い分けを正しく理解していなくても、エージェント側が適切な判断を行えるようになる。

## 実装方針

`autodev-start-new-task` スキルの手順 1 にトリアージステップを追加し、タスクの規模・性質を分析して以下のルーティングを提案する:

1. **方向性が不明確 → discussion**: アイデアが曖昧、要件が整理されていない → `/autodev-discussion` を提案
2. **技術的不確実性が高い → survey**: 技術選定や実現可能性の調査が必要 → `/autodev-start-new-survey` を提案
3. **大きすぎる → project**: 複数タスクに分解すべきスコープ → `/autodev-start-new-project` を提案
4. **数時間〜半日で完了する具体的な実装 → そのまま続行**

既存の手順はナンバリングを振り直す。ルーティング時にタスク README が既に作成されている場合は、トリアージ結果を作業ログに記録する。

### 更新対象

- `.claude/skills/autodev-start-new-task/SKILL.md` — ローカル版
- `nix/programs/claude-code/skills/autodev-init/templates/skills/autodev-start-new-task/SKILL.md` — テンプレート版

## 完了条件

- [x] `autodev-start-new-task` スキルにトリアージステップが追加されている
- [x] テンプレート版も同様に更新されている
- [x] トリアージの判断基準が明確に記載されている
- [x] lint が通る

## 作業ログ

- 2026-02-27: ローカル版・テンプレート版の両方にトリアージステップを手順 1 として追加。既存手順のナンバリングを振り直し。続行条件を「数時間〜半日」に変更。ルーティング時のタスク README への記録手順も追加。
