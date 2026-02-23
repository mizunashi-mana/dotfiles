# autodev-replan スキルの作成

## 目的

steering plan ドキュメントのロードマップを再策定するスキル `autodev-replan` を作成する。

## 関連

- Issue: https://github.com/mizunashi-mana/dotfiles/issues/171

## 実装方針

1. `.claude/skills/autodev-replan/SKILL.md` を作成（スキル本体）
2. `nix/programs/claude-code/skills/autodev-init/templates/skills/autodev-replan/SKILL.md` にテンプレートを追加
3. `nix/programs/claude-code/skills/autodev-init/SKILL.md` のスキル一覧テーブルに `autodev-replan` を追記

## 完了条件

- [ ] スキル本体 `.claude/skills/autodev-replan/SKILL.md` が作成されている
- [ ] テンプレート `nix/programs/claude-code/skills/autodev-init/templates/skills/autodev-replan/SKILL.md` が作成されている
- [ ] autodev-init の SKILL.md スキル一覧テーブルに `autodev-replan` が追記されている
- [ ] `devenv shell lint-all` が通る

## 作業ログ

- 2026-02-23: タスク開始
