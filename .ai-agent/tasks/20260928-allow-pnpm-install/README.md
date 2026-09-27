# pnpm install を Claude Code の allow list に追加

## 目的・ゴール

Claude Code で `pnpm install` を実行するたびに権限確認が挟まるため、
home-manager 管理のグローバル allow list に追加して確認を不要にする。

## 実装方針

`nix/programs/claude-code/default.nix` の `permissions.allow` に
`"Bash(pnpm install)"` を追加する（アルファベット順の位置に挿入）。

既存の npm 系エントリの流儀に合わせ、ワイルドカードなしの完全一致とする。

- `Bash(npm install)` / `Bash(npm ci)` は引数なしの完全一致
- 依存を追加する `npm install <pkg>` は allow していない

`pnpm install` も同様に、ロックファイルどおりのインストールのみを許可し、
`pnpm install <pkg>`（依存追加）は確認を挟む挙動を維持する。

なお本リポジトリ自体は pnpm を使っていないため、プロジェクト側の
`.claude/settings.json` ではなくグローバル設定に入れる。

## 完了条件

- [x] `nix/programs/claude-code/default.nix` に `"Bash(pnpm install)"` が追加されている
- [x] `devenv shell lint-all` が通る
- [x] PR を作成（`/autodev-create-pr`） → https://github.com/mizunashi-mana/dotfiles/pull/315

## 作業ログ

- 2026-09-28: `nix/programs/claude-code/default.nix` に `"Bash(pnpm install)"` を追加
- 2026-09-28: `devenv shell lint-all` pass（pre-commit 全項目 + nix flake check）
- 2026-09-28: PR 作成 → https://github.com/mizunashi-mana/dotfiles/pull/315
