# replace-claude-mermaid-with-html-sync-server

## 目的・ゴール

claude-mermaid MCP パッケージを削除し、mcp-html-sync-server に置き換える。
mcp-html-sync-server は Mermaid に限定されず、HTML 全般のリアルタイムプレビューが可能な MCP サーバー。

## 実装方針

### claude-mermaid の削除

- `nix/programs/claude-mermaid/` ディレクトリを削除
- `nix/programs/default-darwin.nix` から claude-mermaid の import を削除
- `nix/packages/default.nix` から claude-mermaid のビルド設定を削除
- `nix/node2nix/node-packages.json` から claude-mermaid を削除
- node2nix を再実行して node-packages.nix を更新

### mcp-html-sync-server の追加

- `nix/node2nix/node-packages.json` に mcp-html-sync-server を追加
- node2nix を再実行して node-packages.nix を更新
- `nix/packages/default.nix` にビルド設定を追加（必要に応じて）
- `nix/programs/mcp-html-sync-server/default.nix` を新規作成
- `nix/programs/default-darwin.nix` に import を追加
- Claude Code の MCP 設定に mcp-html-sync-server を追加（`nix/programs/claude-code/settings.json`）

### スキルファイルの更新

- 4 つの autodev スキルの Mermaid 図セクションを mcp-html-sync-server 対応に更新
  - autodev-discussion
  - autodev-start-new-task
  - autodev-start-new-survey
  - autodev-start-new-project

## 完了条件

- [x] claude-mermaid に関するすべての Nix 設定が削除されている
- [x] mcp-html-sync-server が Nix パッケージとしてインストールされている
- [x] Claude Code の MCP 設定に mcp-html-sync-server が追加されている
- [x] 4 つのスキルファイルが HTML 汎用可視化対応に更新されている
- [x] `devenv shell lint-all` が通る

## 作業ログ

- 2026-02-28: タスク開始
- 2026-02-28: 実装完了。claude-mermaid を削除し mcp-html-sync-server に置き換え。スキルは Mermaid 限定から HTML 汎用可視化に拡張
