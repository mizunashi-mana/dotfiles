# Codex のサンドボックスでネットワークを許可する

## 目的

Codex の `workspace-write` サンドボックス内からネットワークに出られるようにし、パッケージの取得などがサンドボックスで止まらないようにする。

## 方針

- `nix/programs/codex/default.nix` の `settings` に `sandbox_workspace_write.network_access = true;` を足す。生成される `config.toml` には `[sandbox_workspace_write] network_access = true` として出る

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `nishiyamanomacbook-pro` と `nishiyamanomacbook-air` の darwin 設定がビルドでき、生成された `config.toml` に `[sandbox_workspace_write]` と `network_access = true` が入っている
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-10-22: 開始
