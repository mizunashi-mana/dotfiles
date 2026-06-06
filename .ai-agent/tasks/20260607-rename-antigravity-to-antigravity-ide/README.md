# antigravity を antigravity-ide にリネーム + gemini-cli を antigravity-cli へ切替

## 目的・ゴール

1. Antigravity IDE の Nix モジュール・Homebrew cask・dock アプリ参照を、実際の cask 名 `antigravity-ide` と
   インストールされるアプリ名 `Antigravity IDE.app` に合わせて修正する。
2. Gemini CLI モジュールを Antigravity CLI に切り替える（インストールするツール自体を変更）。

### 背景

- Homebrew cask の正式名は `antigravity-ide`（Google Antigravity IDE）。現状の設定では `antigravity` を指定している。
- cask がインストールするアプリは `Antigravity IDE.app` だが、dock の persistent-apps は `/Applications/Antigravity.app` を参照しており不整合。
- home-manager 上流で `programs.gemini-cli` は `programs.antigravity-cli` にリネームされ、`gemini-cli.nix` モジュールは廃止された。
  この新オプションは更新後の home-manager にのみ存在するため、flake.lock の更新が必要。
- `antigravity-cli` パッケージ（nixpkgs, 1.0.3）のバイナリ名は `agy`。agent-skills-nix には `targets.antigravity` が存在する。

## 実装方針

### Antigravity IDE（cask / dock）

1. モジュールディレクトリ `nix/programs/google-antigravity/` を `nix/programs/antigravity-ide/` にリネーム。
2. `nix/programs/antigravity-ide/default.nix` の cask を `antigravity` → `antigravity-ide` に変更。
3. `nix/programs/default-darwin.nix` の import パスを `./google-antigravity` → `./antigravity-ide` に変更。
4. `nix/nix-darwin/system/default.nix` の dock アプリ参照を
   `/Applications/Antigravity.app` → `/Applications/Antigravity IDE.app` に変更。

### Antigravity CLI（gemini-cli からの切替）

5. モジュールディレクトリ `nix/programs/gemini-cli/` を `nix/programs/antigravity-cli/` にリネーム。
6. モジュール内容を `programs.antigravity-cli`（package = `antigravity-cli`）・`targets.antigravity.enable` に変更。
7. import パス（`default-common.nix` / `devcontainer-claude/default.nix`）を `antigravity-cli` に変更。
8. `claude-code/default.nix` の権限を `Bash(gemini:*)` → `Bash(agy:*)` に変更。
9. `flake.lock` を更新（home-manager に `programs.antigravity-cli` オプションを取り込むため）。

## 完了条件

- [x] cask が `antigravity-ide` に変更されている
- [x] dock の persistent-apps が `Antigravity IDE.app` を参照している
- [x] antigravity-ide モジュールディレクトリ / import パスがリネームされている
- [x] gemini-cli モジュールが antigravity-cli に切り替わっている（package = `antigravity-cli`、`Bash(agy:*)`）
- [x] flake.lock を更新し home-manager の `programs.antigravity-cli` を解決できる
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
- 2026-06-07: PR #282 作成後、追加要望で gemini-cli → antigravity-cli の切替を同一 PR に追加。
  - home-manager 上流で `programs.gemini-cli` が `programs.antigravity-cli` に改名済みであることを確認（`gemini-cli.nix` は廃止）。
    コミット済み flake.lock の home-manager（rev `7d8127d`）では新オプションが存在せず評価エラーになるため、`nix flake update` を実施。
  - `nix/programs/gemini-cli/` → `nix/programs/antigravity-cli/`（`git mv`）、package を `antigravity-cli`（bin: `agy`）に指定。
  - agent-skills のターゲットを `gemini` → `antigravity` に変更。
  - import パス（`default-common.nix` / `devcontainer-claude`）と `claude-code` の権限（`Bash(agy:*)`）を更新。
  - flake.lock は全 input が更新された（home-manager / nixpkgs / agent-skills 他）。ユーザー指示によりそのまま保持。
  - darwin / home 両構成の評価成功・`devenv shell lint-all` で `all checks passed!` を再確認。
