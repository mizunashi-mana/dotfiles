# claude-code-post-setup-script

## 目的・ゴール

`nix/programs/claude-code/default.nix` に以下の2つの機能を追加する:

1. セットアップ後に任意のスクリプトを実行できる仕組み（`home.activation` の活用）
2. `claude mcp add --scope user` による MCP サーバーのユーザースコープ登録

## 実装方針

- `claude-code/default.nix` に `postSetupScript` パラメータを追加し、`home.activation.claudeCodePostSetup` で実行
- 各 MCP プログラムモジュール（`playwright-mcp`, `mcp-html-artifacts-preview`）が自身の `home.activation` エントリで `claude mcp add --scope user` を実行
- `npx` は使わず、Nix ストアパスの `bin/` を直接指定

## 完了条件

- [x] `postSetupScript` で任意スクリプトを activation 時に実行可能
- [x] MCP サーバーをユーザースコープで登録可能
- [x] `devenv shell lint-all` が通る
- [x] 既存の設定が壊れない

## 作業ログ

- `claude-code/default.nix`: `postSetupScript` パラメータ追加、`home.activation.claudeCodePostSetup` 追加
- `playwright-mcp/default.nix`: `home.activation.claudeMcpPlaywright` で `claude mcp add --scope user` 実行
- `mcp-html-artifacts-preview/default.nix`: `home.activation.claudeMcpHtmlArtifactsPreview` で `claude mcp add --scope user` 実行
- `devenv shell lint-all` 全パス
