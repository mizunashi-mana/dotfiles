# helm の追加

## 目的・ゴール

dotfiles に Helm パッケージマネージャーを追加する。

## バージョン調査結果

| ソース           | バージョン |
| ---------------- | ---------- |
| nixpkgs unstable | 3.19.1     |
| Homebrew         | 4.1.3      |

Helm 4 はメジャーバージョンアップ（2025年後半リリース）。nixpkgs unstable はまだ 3.x 系。

## 実装方針

Homebrew 経由でインストールする（nixpkgs のバージョンが 3.x で古いため）。

- `nix/nix-darwin/homebrew/default.nix` に `brews = [ "helm" ];` を追加
- macOS のみの対象（darwin 固有）

## 完了条件

- [x] Homebrew 設定に helm が追加されている
- [x] `devenv shell lint-all` が通る
- [x] PR 作成 (#248)

## 作業ログ

- 2026-04-02: タスク開始、バージョン調査完了
- 2026-04-02: nixpkgs 3.19.1 vs brew 4.1.3、nix での代替手段も調査。brew で進める方針に決定
- 2026-04-02: 実装完了、lint pass
