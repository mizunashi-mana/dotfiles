# 技術アーキテクチャ

## 技術スタック

| カテゴリ               | 技術                      |
| ---------------------- | ------------------------- |
| パッケージ管理         | Nix flakes                |
| ユーザー環境管理       | Home Manager              |
| macOS システム管理     | nix-darwin                |
| 開発環境               | devenv                    |
| flake 構成             | flake-parts               |
| フォーマッタ           | treefmt-nix (fish_indent) |
| シェル                 | Fish                      |
| Node.js パッケージ管理 | node2nix                  |
| エディタ               | VS Code, Neovim, Emacs    |
| バージョン管理         | Git + GitHub              |
| CI/CD                  | GitHub Actions            |
| コンテナ               | Docker (Colima)           |
| シークレット管理       | 1Password (shell-plugins) |

## Nix flake inputs

- `nixpkgs` (unstable)
- `nixpkgs-stable` (nixos-25.05)
- `flake-parts`
- `treefmt-nix`
- `home-manager`
- `nix-darwin`
- `_1password-shell-plugins`
- `nix-vscode-extensions`
- `agent-skills`
- `anthropic-skills`

## アーキテクチャ概要

```
flake.nix
├── darwinConfigurations (macOS)
│   ├── nishiyamanomacbook-air → nix-darwin + Home Manager
│   └── nishiyamanomacbook-pro → nix-darwin + Home Manager
├── homeConfigurations (Linux/Container)
│   ├── devcontainer → Home Manager のみ
│   ├── devcontainer-claude → Home Manager のみ
│   └── desktop-62r22ok → Home Manager のみ
└── perSystem
    └── treefmt (フォーマッタ設定)
```

各ホストは `nix/hosts/{hostname}/default.nix` で定義され、
`nix/programs/` 配下の個別プログラムモジュールを組み合わせて構成される。

## 開発環境

### セットアップ

```bash
# 新規マシン
./setup.sh

# 開発シェル
devenv shell
```

### 主要コマンド

| コマンド                                 | 説明                                |
| ---------------------------------------- | ----------------------------------- |
| `devenv shell`                           | 開発シェルに入る                    |
| `devenv shell lint-all`                  | pre-commit + nix flake check を実行 |
| `devenv shell update-pkgs`               | flake lock + node2nix を更新        |
| `./script/node2nix-update.sh`            | Node.js パッケージを更新            |
| `darwin-rebuild switch --flake .#<host>` | macOS 設定をビルド・適用            |
| `home-manager switch --flake .`          | Home Manager 設定を適用             |

### ビルド対象

| ターゲット   | コマンド                                         |
| ------------ | ------------------------------------------------ |
| macOS        | `darwin-rebuild switch --flake .#<hostname>`     |
| NixOS        | `sudo nixos-rebuild switch --flake .#<hostname>` |
| Home Manager | `home-manager switch --flake .`                  |

## Git Hooks (pre-commit)

- `actionlint`: GitHub Actions ワークフローの lint
- `nixfmt-rfc-style`: Nix コードのフォーマット
- `prettier`: 汎用フォーマッタ
- `pretty-format-json`: JSON フォーマット（autofix）
- `shellcheck`: シェルスクリプトの静的解析
- `shfmt`: シェルスクリプトのフォーマット
- `taplo`: TOML フォーマット

## CI/CD

- `.github/workflows/lint.yml`: lint チェック
- `.github/workflows/deploy-docker-image.yml`: Docker イメージのデプロイ
