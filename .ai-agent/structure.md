# dotfiles ディレクトリ構成

## 全体構造

```
dotfiles/
├── flake.nix                    # Nix flake メインエントリポイント
├── flake.lock                   # flake 依存関係ロックファイル
├── devenv.nix                   # devenv 開発環境設定
├── devenv.yaml                  # devenv 設定
├── devenv.lock                  # devenv ロックファイル
├── setup.sh                     # 新規マシンセットアップスクリプト
├── CLAUDE.md                    # Claude Code 向けプロジェクト説明
├── README.md                    # プロジェクト README
├── LICENSE                      # ライセンス情報
├── .ai-agent/                   # AI エージェント向けドキュメント
│   ├── steering/                # 戦略的ガイドドキュメント
│   │   ├── product.md           # プロダクトビジョン・対象環境
│   │   ├── tech.md              # 技術スタック・開発コマンド
│   │   └── work.md              # 開発ワークフロー・規約
│   ├── structure.md             # このファイル
│   ├── projects/                # 長期プロジェクト管理（.gitkeep）
│   ├── tasks/                   # 個別タスク管理
│   └── surveys/                 # 技術調査・検討
├── .claude/                     # Claude Code 設定
│   ├── settings.local.json      # ローカル設定
│   └── skills/                  # autodev スキル
│       ├── autodev-create-issue/
│       ├── autodev-create-pr/
│       ├── autodev-discussion/
│       ├── autodev-import-review-suggestions/
│       ├── autodev-replan/
│       ├── autodev-review-pr/
│       ├── autodev-start-new-project/
│       ├── autodev-start-new-survey/
│       ├── autodev-start-new-task/
│       ├── autodev-steering/
│       └── autodev-switch-to-default/
├── .github/                     # GitHub 設定
│   ├── PULL_REQUEST_TEMPLATE.md # PR テンプレート
│   ├── copilot-instructions.md  # Copilot 設定
│   ├── dependabot.yml           # Dependabot 設定
│   └── workflows/               # GitHub Actions
│       ├── lint.yml             # lint チェック
│       └── deploy-docker-image.yml # Docker イメージデプロイ
├── nix/                         # Nix 設定モジュール群
│   ├── hosts/                   # ホスト別設定
│   ├── programs/                # プログラム別設定モジュール
│   ├── home-manager/            # Home Manager 共通設定
│   ├── nix-darwin/              # macOS (nix-darwin) 設定
│   ├── node2nix/                # Node.js パッケージ管理
│   └── packages/                # カスタム Nix パッケージ
├── devcontainer/                # 開発コンテナ
│   ├── Dockerfile               # コンテナイメージ定義
│   ├── Dockerfile.host          # ホスト用コンテナイメージ
│   └── updateUID.sh             # UID 更新スクリプト
├── script/                      # ユーティリティスクリプト
│   └── node2nix-update.sh       # node2nix パッケージ更新
└── tasks/                       # セットアップタスクランナー
    ├── base/install.sh          # 基本ツールインストール
    ├── homebrew/install.sh      # Homebrew インストール
    ├── nix/install.sh           # Nix インストール
    ├── post-darwin-setup/setup.sh  # macOS 後処理
    └── post-linux-setup/setup.sh   # Linux 後処理
```

## 主要ディレクトリの詳細

### `nix/hosts/`

ホスト固有の設定。各ホストは `default.nix` で `nix/programs/` のモジュールを組み合わせて構成する。

| ホスト                    | プラットフォーム                  |
| ------------------------- | --------------------------------- |
| `nishiyamanomacbook-air/` | macOS (aarch64-darwin)            |
| `nishiyamanomacbook-pro/` | macOS (aarch64-darwin)            |
| `desktop-62r22ok/`        | Linux (NixOS)                     |
| `devcontainer/`           | Linux (コンテナ)                  |
| `devcontainer-claude/`    | Linux (AI エージェント用コンテナ) |

### `nix/programs/`

プログラムごとの設定モジュール。各ディレクトリに `default.nix` を持つ。
共通設定ファイル:

- `default.nix`: 全プログラムをまとめるエントリポイント
- `default-common.nix`: 全環境共通のプログラム一覧
- `default-darwin.nix`: macOS 固有のプログラム一覧

一部のプログラムモジュールはサブディレクトリを持つ。特に `claude-code/` は Nix 管理のグローバルスキルを含む:

- `claude-code/skills/autodev-init/`: autodev スキル群のテンプレートとブートストラップスキル
- `claude-code/skills/merge-dependabot-bump-pr/`: dependabot PR のレビュー＆マージスキル
- `claude-code/skills/review/`: デフォルト review スキルを無効化するダミースキル

### `nix/home-manager/`

Home Manager の共通設定モジュール。

- `default.nix`: エントリポイント
- `editorconfig/`: EditorConfig 設定
- `home/`: ホームディレクトリ設定
- `nix/`: Nix 自体の設定
- `programs/`: Home Manager プログラム設定

### `nix/nix-darwin/`

macOS 固有のシステム設定。

- `default.nix`: エントリポイント
- `home-manager/`: macOS 向け Home Manager 統合
- `homebrew/`: Homebrew 連携
- `nix/`: Nix 設定
- `system/`: macOS システム設定
- `users/`: ユーザー設定

### `nix/node2nix/`

Node.js パッケージの Nix 管理。

- `node-packages.json`: パッケージ宣言
- `node-packages.nix`: 自動生成されたパッケージ定義
- `node-env.nix`: Node.js 環境設定
- `default.nix`: エントリポイント

### `tasks/`

`setup.sh` から呼び出されるセットアップタスク群。
各タスクは独立した `install.sh` または `setup.sh` を持つ。
