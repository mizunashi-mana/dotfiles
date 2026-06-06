# antigravity を antigravity-ide にリネーム

## 目的・ゴール

Antigravity の Nix モジュール・Homebrew cask・dock アプリ参照を、実際の cask 名 `antigravity-ide` と
インストールされるアプリ名 `Antigravity IDE.app` に合わせて修正する。

### 背景

- Homebrew cask の正式名は `antigravity-ide`（Google Antigravity IDE）。現状の設定では `antigravity` を指定している。
- cask がインストールするアプリは `Antigravity IDE.app` だが、dock の persistent-apps は `/Applications/Antigravity.app` を参照しており不整合。

## 実装方針

1. モジュールディレクトリ `nix/programs/google-antigravity/` を `nix/programs/antigravity-ide/` にリネーム。
2. `nix/programs/antigravity-ide/default.nix` の cask を `antigravity` → `antigravity-ide` に変更。
3. `nix/programs/default-darwin.nix` の import パスを `./google-antigravity` → `./antigravity-ide` に変更。
4. `nix/nix-darwin/system/default.nix` の dock アプリ参照を
   `/Applications/Antigravity.app` → `/Applications/Antigravity IDE.app` に変更。
5. `.ai-agent/structure.md` などにモジュール名の記載があれば追従（要確認）。

## 完了条件

- [x] cask が `antigravity-ide` に変更されている
- [x] dock の persistent-apps が `Antigravity IDE.app` を参照している
- [x] モジュールディレクトリ / import パスがリネームされている
- [x] `devenv shell lint-all` が通る
- [x] PR を作成（`/autodev-create-pr`） → https://github.com/mizunashi-mana/dotfiles/pull/282

## 作業ログ

- 2026-06-07: タスク開始。トリアージの結果そのまま start-new-task で続行。
  `brew info --cask antigravity-ide` で正式 cask 名 `antigravity-ide` とアプリ名 `Antigravity IDE.app` を確認。
- 2026-06-07: 実装完了。以下4点を変更。
  - `nix/programs/google-antigravity/` → `nix/programs/antigravity-ide/`（`git mv`）
  - cask `antigravity` → `antigravity-ide`
  - import パス `./google-antigravity` → `./antigravity-ide`
  - dock アプリ `/Applications/Antigravity.app` → `/Applications/Antigravity IDE.app`
  - `devenv shell lint-all` で `all checks passed!` を確認。
