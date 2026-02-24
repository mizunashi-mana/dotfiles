# プロダクトビジョン

## ミッション

複数の macOS / Linux / コンテナ環境で一貫した開発環境を宣言的に管理し、
新しいマシンやコンテナでも最小限の手順で同一の環境を再現できるようにする。

## ターゲットユーザー

- リポジトリオーナー自身（mizunashi-mana）

## 対象環境

| ホスト                 | プラットフォーム       | 用途                          |
| ---------------------- | ---------------------- | ----------------------------- |
| nishiyamanomacbook-air | macOS (aarch64-darwin) | メイン開発機                  |
| nishiyamanomacbook-pro | macOS (aarch64-darwin) | 開発機                        |
| desktop-62r22ok        | Linux (NixOS)          | デスクトップ                  |
| devcontainer           | Linux (コンテナ)       | 開発コンテナ                  |
| devcontainer-claude    | Linux (コンテナ)       | AI エージェント用開発コンテナ |

## 主要機能

- **宣言的環境管理**: Nix flake + Home Manager でパッケージとドットファイルを一元管理
- **macOS システム設定**: nix-darwin によるシステムレベルの設定管理
- **プログラム設定**: 多数のプログラムの設定を個別モジュールとして管理
- **開発コンテナ**: Docker イメージとしてビルド可能な開発環境
- **セットアップ自動化**: `setup.sh` による新規マシンのブートストラップ
- **コード品質管理**: pre-commit hooks による自動フォーマット・lint
- **AI エージェント支援**: autodev スキル群と agent-skills-nix による開発ワークフロー自動化
