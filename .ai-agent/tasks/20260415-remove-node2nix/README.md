# node2nix からの脱却

## 目的・ゴール

node2nix で管理している全 5 パッケージを nixpkgs または `buildNpmPackage` に移行し、node2nix 関連コードを完全に削除する。

## 実装方針

1. `@openai/codex` → `packages.pkgs.codex` に切り替え
2. `@playwright/mcp` → `packages.pkgs.playwright-mcp` に切り替え（バイナリ名調整）
3. `@playwright/cli` → `packages.pkgs.playwright-driver` または代替手段
4. `@mizunashi_mana/cc-voice-reporter` → `buildNpmPackage` で自前ビルド
5. `@mizunashi_mana/mcp-html-artifacts-preview` → `buildNpmPackage` で自前ビルド
6. `nix/node2nix/` 削除、`nix/packages/default.nix` から node2nix 参照削除
7. `devenv.nix` から node2nix 関連スクリプト削除
8. `script/node2nix-update.sh` 削除

## 完了条件

- [x] 全 5 パッケージが node2nix 以外の手段で提供される
- [x] `nix/node2nix/` ディレクトリが削除されている
- [x] `script/node2nix-update.sh` が削除されている
- [x] `devenv.nix` から node2nix 関連が削除されている
- [x] `devenv shell lint-all` が通る
- [ ] PR を作成

## 作業ログ

- `@openai/codex` → nixpkgs の `codex` (Rust版) に移行。`programs.codex` のデフォルトパッケージを使用
- `@playwright/mcp` → nixpkgs の `playwright-mcp` に移行。バイナリ名 `mcp-server-playwright` に合わせて調整
- `@playwright/cli` → nixpkgs の `playwright-test` に移行（`playwright` コマンドが含まれる）
- `@mizunashi_mana/cc-voice-reporter` → `buildNpmPackage` + `fetchFromGitHub` で自前ビルド定義作成
- `@mizunashi_mana/mcp-html-artifacts-preview` → `buildNpmPackage` + `fetchFromGitHub` で自前ビルド定義作成
- `nix/node2nix/` ディレクトリ削除、`script/node2nix-update.sh` 削除
- `devenv.nix` から node2nix パッケージ・スクリプトを削除
- `nix/packages/default.nix` から node2nix 参照を削除し、新パッケージ定義を追加
- `devenv shell lint-all` 通過確認済み
- カスタムパッケージ 2 つのビルド・動作確認済み
