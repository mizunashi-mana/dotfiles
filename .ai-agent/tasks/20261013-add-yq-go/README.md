# yq-go の追加

## 目的・ゴール

YAML / JSON / TOML / XML を jq 風の構文で扱える CLI `yq`（Go 実装、mikefarah/yq）を dotfiles に追加し、
全ホストで利用できるようにする。

## バージョン調査結果

| ソース                               | バージョン | 備考                |
| ------------------------------------ | ---------- | ------------------- |
| upstream 最新                        | 4.54.1     | 2026-09-29 リリース |
| nixpkgs unstable（本リポジトリ pin） | 4.54.1     | upstream と同一     |

- nixpkgs パッケージ: `yq-go`、メンテナ 3 名
- `platforms` に `aarch64-darwin` / linux 各種を含む
- バイナリキャッシュ済み（`nix build --dry-run` で 5.2 MiB の fetch のみ）

### 判断

**nixpkgs unstable を採用する。** upstream 最新と同一。

## 実装方針

`nix/programs/gws` と同じ粒度で新規モジュールを作成する。

1. `nix/programs/yq-go/default.nix` を作成し、`packages.pkgs.yq-go` を `home.packages` に追加する
   - home-manager に yq 用の `programs.*` モジュールはないため `home.packages` で導入する
2. `nix/programs/default-common.nix` の `programs` リストの `jq` の直後に追加する
   - jq と同様に汎用ツールのため全ホスト対象とする
   - ただし `devcontainer-claude` は `default-common.nix` を使わず最小構成のツールだけを個別に追加しているホスト（jq も未導入）のため、jq と同じく対象外とする
3. `.ai-agent/structure.md` は `nix/programs/` を個別列挙していないため更新不要

## 完了条件

- [x] `nix/programs/yq-go/default.nix` が作成されている
- [x] `nix/programs/default-common.nix` に登録されている
- [x] macOS / Linux ホストで `yq-go-4.54.1` が解決される
- [x] `devenv shell lint-all` が通る
- [ ] PR を作成（`/autodev-create-pr`）

## 作業ログ

- 2026-10-13: タスク開始。バージョン・メンテ状況調査完了、nixpkgs unstable 採用を決定
- 2026-10-13: `nix/programs/yq-go/` を作成、`default-common.nix` の jq の直後に登録
- 2026-10-13: 導入結果を eval で検証
  - `nishiyamanomacbook-air` / `nishiyamanomacbook-pro` → `yq-go-4.54.1`
  - `desktop-62r22ok` / `devcontainer` → `yq-go-4.54.1`
  - `devcontainer-claude` → 未導入（`default-common.nix` を使わない最小構成ホストのため。jq と同じ扱い）
- 2026-10-13: `devenv shell lint-all` pass（pre-commit 全項目 + nix flake check）
