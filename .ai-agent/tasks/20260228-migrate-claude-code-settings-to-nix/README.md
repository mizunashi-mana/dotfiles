# migrate-claude-code-settings-to-nix

## 目的・ゴール

`nix/programs/claude-code/settings.json` を home-manager の `programs.claude-code.settings` nix 表現に移行する。
これにより、`additionalDirectories` などの環境依存パスを nix 変数で絶対パスとして記述できるようにする。

## 実装方針

1. `settings.json` の内容を `programs.claude-code.settings` attrset に変換
2. `additionalDirectories` で `config.home.homeDirectory` を使い絶対パスを生成
3. `home.file.".claude/settings.json"` のエントリを削除
4. `settings.json` ファイル自体を削除
5. `mcpServers` のエントリを削除
6. `statusline.sh` / `skills/` の `home.file` エントリはそのまま維持

## 完了条件

- [x] `settings.json` が削除され、設定が nix 式で記述されている
- [x] `additionalDirectories` が絶対パスで環境非依存になっている
- [x] `devenv shell lint-all` が通る
- [x] ビルドが成功する

## 作業ログ

- settings.json の全設定を default.nix の `programs.claude-code.settings` attrset に移行
- モジュールを `({ config, ... }:` 関数形式にして `config.home.homeDirectory` を利用可能に
- `additionalDirectories` の `~/Library/Caches/ms-playwright/` を `${config.home.homeDirectory}/Library/Caches/ms-playwright/` に変更
- `mcpServers` のエントリを削除
- `settings.json` ファイルを削除
- `devenv shell lint-all` パス確認済み
