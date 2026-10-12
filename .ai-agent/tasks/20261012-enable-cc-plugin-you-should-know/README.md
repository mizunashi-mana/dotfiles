# cc-plugin-you-should-know@builtin の有効化

## 目的・ゴール

Claude Code の builtin プラグイン `cc-plugin-you-should-know@builtin` を、dotfiles 管理の
Claude Code ユーザー設定（`~/.claude/settings.json`）で有効化する。

## 実装方針

- `nix/programs/claude-code/default.nix` の `programs.claude-code.settings` に
  `enabledPlugins = { "cc-plugin-you-should-know@builtin" = true; };` を追加する
- Home Manager が生成する `settings.json` に `enabledPlugins` が出力されることを eval で確認する

## 完了条件

- [x] `nix/programs/claude-code/default.nix` に `enabledPlugins` が追加されている
- [x] 生成される settings に `"cc-plugin-you-should-know@builtin": true` が含まれることを確認
- [x] `devenv shell lint-all` が通る
- [ ] PR を作成（`/autodev-create-pr`）

## 作業ログ

- 2026-10-12: タスク開始。`nix/programs/claude-code/default.nix` の `settings` に `enabledPlugins` を追加する方針で合意
- 2026-10-13: `enabledPlugins = { "cc-plugin-you-should-know@builtin" = true; }` を追加
- 2026-10-13: 生成結果を検証
  - `nishiyamanomacbook-pro` / `nishiyamanomacbook-air` の `programs.claude-code.settings.enabledPlugins` → `{"cc-plugin-you-should-know@builtin":true}`
  - `nishiyamanomacbook-pro` の生成済み `settings.json` をビルドし、`enabledPlugins` に同値が出力されることを確認
- 2026-10-13: `devenv shell lint-all` pass（pre-commit 全項目 + nix flake check）
