# ChatGPT デスクトップの追加

## 目的

ChatGPT のデスクトップアプリを、全 Mac（nishiyamanomacbook-air / nishiyamanomacbook-pro）に入るようにする。

## 方針

- `nix/programs/chatgpt/default.nix`（Homebrew cask `chatgpt` を入れるモジュール）は既にあるが、PR #63（ace1e15、2025-08-03）で `default-darwin.nix` から外されていた。外した理由は PR 本文にもコミットにも残っていない。今回はユーザーが入れたいと言ったので入れ直す。また要らなくなったら、`default-darwin.nix` からこの行を消せばアプリも消える（`homebrew.onActivation.cleanup = "uninstall"` のため）。
- 新しくモジュールは作らず、`nix/programs/default-darwin.nix` の `claude-desktop` の直後で読み込み直す。
- Claude デスクトップと同じく全 Mac に入れる。ホスト別の `extra-programs` には足さない。

## 完了条件

- [x] 両 Mac の darwin 設定で `homebrew.casks` に `chatgpt` が入る（eval で確かめる）
- [x] 両 Mac の darwin 設定がビルドできる
- [x] `devenv shell lint-all` が通る
- [x] レビューを取り込み CI が通った PR → https://github.com/mizunashi-mana/dotfiles/pull/323

## 作業ログ

- 2026-10-19: 開始。対象は全 Mac に決めた
- 2026-10-19: `default-darwin.nix` の `claude-desktop` の直後に `chatgpt` を読み込み直した
- 2026-10-19: 確かめた結果
  - eval: 両 Mac の `homebrew.casks` に `chatgpt` が入る
  - `nix build .#darwinConfigurations.<host>.system`: 両 Mac で通る
  - `devenv shell lint-all`: 通る
- 2026-10-19: PR #323 を作成
- 2026-10-19: `/autodev-review-pr` の結果は Critical 0 / Warning 0 / Info 1
  - 取り込み: Info「#63 で外した理由が残っていないので、入れ直す判断を方針に書く」→ 方針に、理由が残っていないこと・入れ直す理由・外し方を書き足した
  - 取り込まなかった指摘: なし
