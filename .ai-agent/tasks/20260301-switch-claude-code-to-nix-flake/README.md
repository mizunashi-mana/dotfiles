# claude-code パッケージを claude-code-nix フレークに切り替え

## 目的・ゴール

claude-code のパッケージソースを node2nix (npm レジストリ経由) から [sadjow/claude-code-nix](https://github.com/sadjow/claude-code-nix) フレークに切り替える。

**理由:**

- node2nix は手動で `node2nix-update.sh` を実行する必要があり、更新が煩雑
- claude-code-nix は hourly で自動更新され、ネイティブバイナリを提供
- Node.js ランタイム依存を排除できる（ネイティブバイナリ使用時）

## 実装方針

1. `flake.nix` に `claude-code-nix` を input として追加
2. `nix/packages/default.nix` で claude-code パッケージを claude-code-nix のものに差し替え
3. `nix/node2nix/node-packages.json` から `@anthropic-ai/claude-code` を削除
4. `nix/node2nix/` の自動生成ファイルを再生成（claude-code エントリを除去）
5. 関連ドキュメント（tech.md, structure.md）を更新

## 完了条件

- [x] `flake.nix` に claude-code-nix input が追加されている
- [x] `nix/packages/default.nix` が claude-code-nix パッケージを参照している
- [x] node2nix から `@anthropic-ai/claude-code` が除去されている
- [x] `nix flake check` が通る
- [x] `devenv shell lint-all` が通る
- [x] ドキュメントが更新されている

## 作業ログ

- flake.nix に `claude-code = { url = "github:sadjow/claude-code-nix"; };` を追加
- nix/packages/default.nix で `inputs.claude-code.packages.${system}.default` を使うよう変更
- node-packages.json から `@anthropic-ai/claude-code` を削除し、node2nix で再生成
- `nix flake check` 通過確認
- tech.md を更新（claude-code-nix を Nix flake inputs に追加）
