# Copilot ガイドライン

このドキュメントは、GitHub Copilot がこのプロジェクトのコードをレビュー・生成する際の指針です。

## プロジェクト概要

これは Nix ベースの dotfiles リポジトリです。以下の技術を使用しています：

- **Nix Flakes**: パッケージ管理
- **Home Manager**: ユーザー環境設定
- **devenv**: 開発環境セットアップ
- **nix-darwin**: macOS システム設定

## ディレクトリ構成

```
dotfiles/
├── flake.nix                 # メイン Nix flake 設定
├── devenv.nix               # devenv 設定
├── setup.sh                 # セットアップスクリプト
├── nix/                     # Nix 設定モジュール
│   ├── home-manager/        # Home Manager 設定
│   ├── hosts/               # ホスト固有設定
│   ├── nix-darwin/          # macOS システム設定
│   ├── node2nix/            # Node.js パッケージ管理
│   │   └── node-packages.json # パッケージ宣言
│   └── programs/            # プログラム別設定
│       ├── claude-code/     # Claude Code 設定
│       ├── fish/            # Fish シェル設定
│       ├── git/             # Git 設定
│       └── vscode/          # VS Code 拡張機能
├── script/                  # ユーティリティスクリプト
└── tasks/                   # タスクランナー
```

## コード生成・編集時の注意点

### Nix コード

- Nix 式は純粋関数型で記述してください
- `let ... in` ブロックを適切に使用してローカル変数を定義してください
- `lib` 関数（`lib.mkIf`, `lib.mkMerge` など）を積極的に活用してください
- オプション定義には `mkOption` を使用し、型を明示してください
- フォーマットは `nixfmt` スタイルに従ってください

### シェルスクリプト

- シバンは `#!/usr/bin/env bash` を使用してください
- `set -euo pipefail` をスクリプト冒頭に記述してください
- 変数展開は `"${var}"` の形式で行ってください
- エラーハンドリングを適切に行ってください

### Node.js パッケージ追加

Node.js パッケージを追加する場合：

1. `nix/node2nix/node-packages.json` を編集
2. `./script/node2nix-update.sh` を実行
3. 生成されたファイルをコミット

## よく使うコマンド

```bash
# 開発シェルに入る
devenv shell

# パッケージ更新
devenv shell update-pkgs

# リント実行
devenv shell lint-all

# macOS ビルド
darwin-rebuild switch --flake .#macbook-air-2nd

# Home Manager ビルド
home-manager switch --flake .
```

## レビュー規約

- レビューコメントは日本語で行ってください
- 指摘は具体的かつ建設的に行い、可能であれば修正案を提示してください
- Nix コードの場合は型安全性と再現性を重視してください
- セキュリティに関わる問題は必ず指摘してください

## コミットメッセージ

- 英語で記述してください
- 動詞の原形で始めてください（例: Add, Fix, Update, Remove）
- 簡潔かつ明確に変更内容を説明してください

## 禁止事項

- ハードコードされた絶対パス（`/Users/username/` など）の使用
- 秘密情報（API キー、パスワードなど）のコミット
- `.envrc` や `.env` ファイルへの秘密情報の記載
- Nix ストアパスの直接参照
