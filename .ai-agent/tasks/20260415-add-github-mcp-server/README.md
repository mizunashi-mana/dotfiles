# github-mcp-server を programs として追加

## 目的・ゴール

nixpkgs unstable の `github-mcp-server` パッケージを programs モジュールとして追加し、darwin 環境で常にインストールされるようにする。

## 実装方針

1. `nix/programs/github-mcp-server/default.nix` を新規作成
   - `home.packages` で `packages.pkgs.github-mcp-server` をインストール
2. `nix/programs/default-darwin.nix` に import を追加

## 完了条件

- [x] `nix/programs/github-mcp-server/default.nix` が存在する
- [x] `nix/programs/default-darwin.nix` に github-mcp-server の import がある
- [x] `devenv shell lint-all` が通る
- [ ] PR を作成

## 作業ログ

- `nix/programs/github-mcp-server/default.nix` を作成（`home.packages` で `packages.pkgs.github-mcp-server` をインストール）
- `nix/programs/default-darwin.nix` に import を追加
- `devenv shell lint-all` 通過確認済み
