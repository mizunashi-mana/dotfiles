# GitHub Actions の action バージョンを更新

## 目的・ゴール

`.github/workflows/` で使用している action を最新リリースに更新する。

本リポジトリは action を commit SHA でピン留めし、末尾コメントにバージョンを記載する
方式を採っている。この形式を維持したまま、SHA とコメントの両方を最新版に揃える。

Dependabot（`github-actions` エコシステム、monthly + cooldown 7 日）は動いているが、
PR #296〜#300 が未マージのまま溜まっており、さらにその後のリリースにも追随できていない。
本タスクでまとめて最新版に更新し、溜まった Dependabot PR を解消する。

## 調査結果

`gh api` で各 action の最新リリースと tag の commit SHA を確認した。

| action                     | 現在    | 最新     | 備考                                 |
| -------------------------- | ------- | -------- | ------------------------------------ |
| actions/checkout           | v6.0.2  | v7.0.1   | メジャー更新                         |
| cachix/install-nix-action  | v31.9.1 | v31.11.1 |                                      |
| cachix/cachix-action       | v17     | v17      | ローリングタグが移動（SHA のみ更新） |
| docker/setup-buildx-action | v4.0.0  | v4.4.1   |                                      |
| docker/metadata-action     | v6.1.0  | v6.2.0   |                                      |
| docker/build-push-action   | v7.2.0  | v7.4.0   |                                      |
| docker/login-action        | v4.2.0  | v4.6.0   |                                      |
| actions/upload-artifact    | v7.0.1  | v7.0.1   | 最新のため変更なし                   |
| actions/download-artifact  | v8.0.1  | v8.0.1   | 最新のため変更なし                   |
| sigstore/cosign-installer  | v4.1.2  | v4.1.2   | 最新のため変更なし                   |

### actions/checkout v7 の破壊的変更

v7.0.0 の変更点は以下の 2 点。いずれも本リポジトリには影響しない。

- `pull_request_target` / `workflow_run` での fork PR チェックアウトをブロック
  → 本リポジトリの workflow は `push` / `pull_request` のみを使用
- action 実装を ESM に移行（内部変更）

### cachix/cachix-action のタグ運用

cachix-action はメジャータグのみ（v17, v16, ...）を発行し、パッチ相当の変更で
タグを移動させる運用。現在のピン `f495f3f`（2026-06-22）に対し、v17 タグは
`38b0826`（2026-09-01）に移動しているため SHA のみ更新する。

## 実装方針

1. `.github/workflows/lint.yml` の 3 つの action を更新
2. `.github/workflows/deploy-docker-image.yml` の action を更新
   - 同じ action が複数箇所に出現するため一括置換する
3. `sigstore/cosign-installer` のコメントが `#v4.1.2` とスペース抜けなので
   他と揃えて `# v4.1.2` に修正する
4. `devenv shell lint-all` で lint を通す
5. PR 作成後、重複する Dependabot PR (#296〜#300) は自動クローズされることを確認する

## 完了条件

- [x] `.github/workflows/lint.yml` の action が最新版になっている
- [x] `.github/workflows/deploy-docker-image.yml` の action が最新版になっている
- [x] 全ての SHA が対応する tag の commit SHA と一致している
- [x] `devenv shell lint-all` が通る
- [ ] PR を作成（`/autodev-create-pr`）

## 作業ログ

- 2026-09-20: タスク開始。トリアージの結果、ゴールが明確で 1 PR 完結の規模のため
  そのまま実装タスクとして続行。各 action の最新リリースと commit SHA を調査
- 2026-09-20: 7 つの action（checkout / install-nix-action / cachix-action /
  setup-buildx-action / metadata-action / build-push-action / login-action）の
  SHA とバージョンコメントを更新。`sigstore/cosign-installer` のコメントを
  `#v4.1.2` → `# v4.1.2` に統一
- 2026-09-20: `gh api` で全 17 箇所・10 種類の SHA が対応タグの commit SHA と
  一致することを逆引き検証（全て OK）
- 2026-09-20: `devenv shell lint-all` pass（actionlint 含む pre-commit 全項目 +
  nix flake check）
