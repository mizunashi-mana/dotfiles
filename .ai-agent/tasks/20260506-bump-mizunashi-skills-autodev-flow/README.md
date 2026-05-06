# mizunashi-mana-skills の autodev フロー改善追従

## 目的・ゴール

`flake.lock` の `mizunashi-mana-skills` を最新コミットに更新し、
autodev プラグインのフロー改善（PR 言語オプション、未 push README 防止、
レビュー後の suggestions 自動取り込み）に追従する。

## 背景

- 当日朝にマージされた PR #267 で `d5d4c1b` (2026-04-26 作成 / 2026-05-05 23:02 push) に更新済み
- その後 upstream に 14 commits / 3 PR が入っている

最新 revision: `2efbdd2` (HEAD as of 2026-05-06T00:43Z)

主要 PR:

- **PR #17** `add-pr-language-option-to-init`
  - autodev-init で PR タイトル・本文の言語を選択可能に
  - PR 言語マーカー保持で多言語対応
  - create-pr スキルが使われずに PR 作成される問題への対応
- **PR #18** `prevent-stranded-readme-after-pr`
  - PR 作成後に未 push の README 変更を残さない完了フローへ更新
  - allowed-tools に新フローで使う git コマンド / Skill 呼び出しを追加
  - 完了時フロー文言を `/autodev-create-pr` の実態に合わせる
- **PR #20** `chain-import-suggestions-after-review`
  - autodev-review-pr 完了後に import-review-suggestions を自動チェーン
  - チェーン経由ユーザー確認の重複注意書きを削除

すべて既存 `autodev` プラグインのテンプレ／フロー改善で、skill 追加・削除なし。
よって `agent-skills-mizunashi-mana/default.nix` の変更は不要見込み。

## 実装方針

1. `nix flake update mizunashi-mana-skills` で `flake.lock` を更新
2. 念のため `agent-skills-mizunashi-mana/default.nix` を確認し、
   skill 一覧に変更が無いことを再確認（変更不要の見込み）
3. `nix flake check --no-build` と darwin host build で動作確認
4. PR を作成

## 完了条件

- [x] `flake.lock` の `mizunashi-mana-skills` が `2efbdd2` 以降を指す
- [x] skill 一覧に変更がないことを確認（あれば追従）
- [x] `nix flake check --no-build` が成功
- [x] darwin host build が成功
- [ ] PR 作成

## 作業ログ

- 2026-05-06: タスク開始。前回タスク (PR #267) 後の 14 commits を確認、
  全て autodev プラグインのフロー改善で構造変更なしと判断。
- 2026-05-06: `nix flake update mizunashi-mana-skills` で revision を
  `d5d4c1b` → `2efbdd2` に更新。
- 2026-05-06: upstream の skill 構成を確認し、`default.nix` の enable リスト
  (autodev-init / detect-\* x4 / merge-dependabot-bump-pr / recommend-bash-allowlist)
  と一致することを確認 → `default.nix` 変更不要。
- 2026-05-06: 動作確認:
  - `nix flake check --no-build`: all checks passed
  - `nix build .#darwinConfigurations.{air,pro}.system`: 成功
  - 出力 bundle に 7 skill + skill-creator が含まれることを確認
  - autodev-init SKILL.md に PR 言語オプションの追加が反映済み
  - Linux host build は platform mismatch (master 既知) のためスキップ
