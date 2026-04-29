# mcp-grafana を programs として追加

## 目的・ゴール

nixpkgs unstable の `mcp-grafana` パッケージを programs モジュールとして追加し、darwin 環境で常にインストールされるようにする。

## 実装方針

1. `nix/programs/mcp-grafana/default.nix` を新規作成
   - `home.packages` で `packages.pkgs.mcp-grafana` をインストール
   - 前例の `github-mcp-server` と同じく、パッケージ提供のみで MCP server の自動登録は行わない
   - 理由: mcp-grafana は `GRAFANA_URL` / `GRAFANA_API_KEY` などの環境変数を必要とし、登録時の構成はユーザーに委ねるのが妥当
2. `nix/programs/default-darwin.nix` の programs リストに import を追加

## 完了条件

- [x] `nix/programs/mcp-grafana/default.nix` が存在する
- [x] `nix/programs/default-darwin.nix` に mcp-grafana の import がある
- [x] `nix flake check` が通る（`devenv shell lint-all` は devenv-nixpkgs の prek パッチ失敗で起動できないため代替検証）
- [x] 両 darwin 設定（macbook-pro / macbook-air）の評価成功
- [x] `nix fmt -- --fail-on-change` で formatter clean
- [ ] PR を作成

## 作業ログ

- `nix/programs/mcp-grafana/default.nix` を作成（`home.packages` で `packages.pkgs.mcp-grafana` をインストール、前例の `github-mcp-server` パターンに準拠）
- `nix/programs/default-darwin.nix` の programs リストに import を追加
- 検証:
  - `nix flake check`: all checks passed
  - `darwinConfigurations.nishiyamanomacbook-pro` 評価成功
  - `darwinConfigurations.nishiyamanomacbook-air` 評価成功
  - `nix fmt -- --fail-on-change`: formatted 5 files (0 changed)
- 補足: `devenv shell lint-all` は devenv-nixpkgs の prek パッチ失敗でシェル起動段階で停止（環境側の既存問題、本タスクとは無関係）
