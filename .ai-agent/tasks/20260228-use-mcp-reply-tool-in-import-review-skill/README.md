# autodev-import-review-suggestions スキルで GitHub MCP reply ツールを使用

## 目的・ゴール

`autodev-import-review-suggestions` スキルのレビューコメント返信処理を、`gh api` コマンドから GitHub MCP の `add_reply_to_pull_request_comment` ツールに移行する。

## 実装方針

1. `allowed-tools` から `"Bash(gh api *)"` を削除し、`mcp__github__add_reply_to_pull_request_comment` を追加
2. 手順 6（レビューコメントへの返信）を MCP ツール使用に書き換え

## 完了条件

- [x] `allowed-tools` に `mcp__github__add_reply_to_pull_request_comment` が含まれている
- [x] `allowed-tools` から `"Bash(gh api *)"` が削除されている
- [x] 手順 6 が `mcp__github__add_reply_to_pull_request_comment` の使用方法で記述されている
- [x] lint チェックをパスする

## 作業ログ

- `allowed-tools` を `"Bash(gh api *)"` → `mcp__github__add_reply_to_pull_request_comment` に変更
- 手順 6 の `gh api` コマンド例を MCP ツールのパラメータ説明に置換
- `devenv shell lint-all` パス確認済み
