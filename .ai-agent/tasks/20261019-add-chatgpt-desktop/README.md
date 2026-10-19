# ChatGPT デスクトップの追加

## 目的

ChatGPT のデスクトップアプリを、全 Mac（nishiyamanomacbook-air / nishiyamanomacbook-pro）に入るようにする。

## 方針

- `nix/programs/chatgpt/default.nix`（Homebrew cask `chatgpt` を入れるモジュール）は既にあるが、PR #63（ace1e15、2025-08-03）で `default-darwin.nix` から外されていた。
- 新しくモジュールは作らず、`nix/programs/default-darwin.nix` の `claude-desktop` の直後で読み込み直す。
- Claude デスクトップと同じく全 Mac に入れる。ホスト別の `extra-programs` には足さない。

## 完了条件

- [x] 両 Mac の darwin 設定で `homebrew.casks` に `chatgpt` が入る（eval で確かめる）
- [x] 両 Mac の darwin 設定がビルドできる
- [x] `devenv shell lint-all` が通る
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-10-19: 開始。対象は全 Mac に決めた
- 2026-10-19: `default-darwin.nix` の `claude-desktop` の直後に `chatgpt` を読み込み直した
- 2026-10-19: 確かめた結果
  - eval: 両 Mac の `homebrew.casks` に `chatgpt` が入る
  - `nix build .#darwinConfigurations.<host>.system`: 両 Mac で通る
  - `devenv shell lint-all`: 通る
