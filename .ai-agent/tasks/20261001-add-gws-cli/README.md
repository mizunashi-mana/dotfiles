# Google Workspace CLI (gws) と gcloud の追加

## 目的・ゴール

dotfiles に Google Workspace CLI (`gws`) を追加する。主な用途は Google Drive からの
ファイルダウンロード（非公開ファイル・Google Docs 系のエクスポートを含む）。
あわせて、`gws auth setup` が要求する Google Cloud CLI (`gcloud`, nixpkgs 上は `google-cloud-sdk`) も追加する。

Google Drive を扱う CLI として rclone / gdown / gdrive3 / gogcli と比較したうえで、
Google Workspace チーム公開（`googleworkspace/cli`）で公式に最も近く、Drive 以外の
Workspace API も扱える `gws` を選定した。

## バージョン調査結果

| ソース                               | バージョン | 備考                |
| ------------------------------------ | ---------- | ------------------- |
| upstream 最新                        | 0.22.5     | 2026-03-31 リリース |
| nixpkgs unstable（本リポジトリ pin） | 0.22.5     | upstream と同一     |

### メンテ状況・注意点

- nixpkgs パッケージ: `gws`、メンテナ 1 名
- `platforms` に `aarch64-darwin` / linux 各種を含む
- バイナリキャッシュ済み（`nix build --dry-run` で fetch のみ）
- upstream README に「not an officially supported Google product」「v1.0 までは破壊的変更あり」と明記
- 認証の `gws auth setup` は `gcloud` を要求する。本環境には gcloud 未導入だったため、
  本タスクで gcloud もあわせて導入する（認証情報自体は dotfiles 管理外）

### gcloud (google-cloud-sdk)

| ソース                               | バージョン | 備考                              |
| ------------------------------------ | ---------- | --------------------------------- |
| upstream 最新（Homebrew gcloud-cli） | 586.0.0    | 週次リリース                      |
| nixpkgs unstable（本リポジトリ pin） | 583.0.0    | 約 3 週遅れ。週次リリースの範囲内 |

- バイナリキャッシュ済み（86 MiB fetch のみ）
- Nix 版は `gcloud components install` による追加コンポーネント導入が使えないが、
  gws の認証用途では本体のみで足りる

### 判断

**いずれも nixpkgs unstable を採用する。** gws は upstream 最新と同一、gcloud も数週遅れ程度で
Homebrew に逃がす理由がない。

## 実装方針

`nix/programs/argocd` と同じ粒度で新規モジュールを作成する。

1. `nix/programs/gws/default.nix` / `nix/programs/google-cloud-sdk/default.nix` を作成し、
   それぞれ `packages.pkgs.gws` / `packages.pkgs.google-cloud-sdk` を `home.packages` に追加する
2. `nix/programs/default-darwin.nix` の `programs` リストに両モジュールを追加する
   - 利用は手元の Mac 想定のため、対象は macOS のみとする
3. `.ai-agent/structure.md` は `nix/programs/` を個別列挙していないため更新不要

## 完了条件

- [x] `nix/programs/gws/default.nix` / `nix/programs/google-cloud-sdk/default.nix` が作成されている
- [x] `nix/programs/default-darwin.nix` に両モジュールが登録されている
- [x] macOS 2 ホストで `gws-0.22.5` / `google-cloud-sdk-583.0.0` が解決される / Linux ホストには入らない
- [x] `devenv shell lint-all` が通る
- [ ] PR を作成（`/autodev-create-pr`）

## 作業ログ

- 2026-10-01: タスク開始。CLI 比較の結果 gws を選定、バージョン・メンテ状況調査完了、nixpkgs unstable 採用を決定
- 2026-10-01: ユーザー要望により gcloud (google-cloud-sdk) も同タスクで追加することに決定
- 2026-10-01: `nix/programs/gws/` / `nix/programs/google-cloud-sdk/` を作成、`default-darwin.nix` に登録
- 2026-10-01: 導入結果を eval で検証
  - `nishiyamanomacbook-air`（user: mizunashi） → `gws-0.22.5`, `google-cloud-sdk-583.0.0`
  - `nishiyamanomacbook-pro`（user: nishiyama-shun） → `gws-0.22.5`, `google-cloud-sdk-583.0.0`
  - `desktop-62r22ok` → 未導入（darwin 限定の意図どおり）
- 2026-10-01: `devenv shell lint-all` pass（pre-commit 全項目 + nix flake check）
