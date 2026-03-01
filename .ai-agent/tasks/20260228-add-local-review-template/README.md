# add-local-review-template

## 目的

autodev スキルのレビュー関連テンプレートに「ローカルレビュー」形式を追加し、GitHub レビュー機能を使わないワークフローに対応する。

関連 Issue: #187

## ゴール

- `autodev-init` の Step 5 でレビュー形式（GitHub / ローカル）を聞き取り、選択に応じたスキルテンプレートを生成する
- ローカルレビュー版の `autodev-review-pr` テンプレートを作成する（`git diff` ベースでレビュー → `.ai-agent/tmp/reviews/` にファイル保存）
- ローカルレビュー版の `autodev-import-review-suggestions` テンプレートを作成する（レビューファイルから読み込み → 対話的に修正）

## 実装方針

### 変更対象

1. **`autodev-init/SKILL.md`** — Step 5 にレビュー形式の聞き取りを追加
2. **`autodev-init/templates/skills/autodev-review-pr/`** — ローカルレビュー版テンプレートを追加
3. **`autodev-init/templates/skills/autodev-import-review-suggestions/`** — ローカルレビュー版テンプレートを追加
4. **`autodev-init/templates/work.md`** — ローカルレビュー形式のフロー説明を追加（init 時に選択に応じて調整）

### レビューファイルの保存先

- パス: `.ai-agent/tmp/reviews/YYYYMMDD-pr-{PR番号}/REVIEW-{連番}.md`
- `.ai-agent/tmp/` は gitignore する（init 時に設定）
- フォーマット: 現行の reviewer 報告フォーマット（マークダウン）をそのまま使用

### テンプレート構成

各スキルについて GitHub 版（現行）とローカル版の 2 テンプレートを用意し、`autodev-init` が聞き取り結果に応じて適切な方を選んでインストールする。

- `templates/skills/autodev-review-pr/SKILL.md` — GitHub 版（現行）
- `templates/skills/autodev-review-pr/SKILL.local.md` — ローカル版（新規）
- `templates/skills/autodev-review-pr/reviewer-spawn-prompt.md` — GitHub 版（現行）
- `templates/skills/autodev-review-pr/reviewer-spawn-prompt.local.md` — ローカル版（新規）
- `templates/skills/autodev-import-review-suggestions/SKILL.md` — GitHub 版（現行）
- `templates/skills/autodev-import-review-suggestions/SKILL.local.md` — ローカル版（新規）

## 完了条件

- [x] ローカルレビュー版 `autodev-review-pr` テンプレート（SKILL.local.md + reviewer-spawn-prompt.local.md）が作成されている
- [x] ローカルレビュー版 `autodev-import-review-suggestions` テンプレート（SKILL.local.md）が作成されている
- [x] `autodev-init/SKILL.md` の Step 5 にレビュー形式の聞き取りが追加されている
- [x] `autodev-init/templates/work.md` にローカルレビュー形式のフロー説明が追加されている
- [x] このリポジトリ自身のスキル（`.claude/skills/`）は PR レビュー形式を維持している
- [x] `devenv shell lint-all` が通る

## 作業ログ

- テンプレート新規作成: `SKILL.local.md` と `reviewer-spawn-prompt.local.md` を autodev-review-pr と autodev-import-review-suggestions に追加
- `autodev-init/SKILL.md` の Step 5 にレビュー形式（GitHub / ローカル）の聞き取りを追加し、テンプレートテーブルを更新
- `templates/work.md` にレビュー形式セクションを追加（GitHub レビュー / ローカルレビュー）
- このリポジトリの `.claude/skills/` は PR レビュー形式を維持（ローカルレビューは使わない）
- `.ai-agent/steering/work.md` は PR レビュー形式の記述を維持
- `.gitignore` に `.ai-agent/tmp/` を追加
- `devenv shell lint-all` 通過確認済み
