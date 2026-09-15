# devcontainer image のビルドをデフォルト無効にする

## 目的・ゴール

`./setup.sh` は現在、macOS（`darwin`）および汎用 Linux（`default`）のセットアップで
無条件に `devcontainer/Dockerfile.host` の Docker イメージ
（`mizunashi-mana/dotfiles/devcontainer-claude-host`）をビルドする。

このビルドは

- Docker（Colima）の起動待ち（最大 60 秒）が発生する
- ベースイメージの `--pull` とイメージビルドで時間・帯域を消費する
- 完了後に `docker system prune -f` まで走る

という重いステップだが、devcontainer を使わないセットアップでは不要。
セットアップの既定動作を軽くするため、**Docker イメージのビルドをオプトイン**にする。

## 実装方針

オプトインの指定方法は**環境変数 `BUILD_DOCKER_IMAGE`**（既存の `TRACE` /
`SKIP_CLEAN` / `WAIT_DOCKER_LIMIT` と同じスタイル）とする。
`BUILD_DOCKER_IMAGE` は既に内部変数として使われており、判定も
`[ -n "${BUILD_DOCKER_IMAGE:-}" ]` になっているため、
`SETUP_TYPE` 分岐での代入を削除するだけで環境変数がそのまま効く形になる。

1. `setup.sh` の `SETUP_TYPE` 分岐（`darwin` / `default` / `linux-container`）から
   `BUILD_DOCKER_IMAGE` の代入を削除し、外部から渡された値のみを見るようにする
2. `usage()` の Environment variables に `BUILD_DOCKER_IMAGE=1` の説明と
   使用例を追記する
3. Docker 待機・ビルド・`docker system prune -f` は従来どおり
   `BUILD_DOCKER_IMAGE` が非空のときのみ実行する（既存ロジックのまま）
4. `README.md` の Setup セクションに、Docker イメージも併せてビルドする場合の
   コマンド（`BUILD_DOCKER_IMAGE=1 ./setup.sh`）を追記する

## 完了条件

- [x] `./setup.sh` がデフォルトで Docker イメージをビルドしない
- [x] `BUILD_DOCKER_IMAGE=1 ./setup.sh` でビルドされる
- [x] `./setup.sh --help` に環境変数の説明が表示される
- [x] `README.md` にオプトインの記載がある
- [x] `devenv shell lint-all` が通る
- [ ] PR を作成（`/autodev-create-pr`）

## 作業ログ

- 2026-09-15: タスク開始。`setup.sh` の現状を確認し、オプトイン方式の方針を策定
- 2026-09-15: オプトインの指定方法を環境変数 `BUILD_DOCKER_IMAGE` に決定
- 2026-09-15: `setup.sh` から `BUILD_DOCKER_IMAGE` の代入 3 箇所（darwin / default /
  linux-container）を削除し、環境変数のみで制御する形に変更。
  `usage()` に `BUILD_DOCKER_IMAGE` / `WAIT_DOCKER_LIMIT` / `SKIP_CLEAN` を追記
- 2026-09-15: `README.md` の Setup セクションに
  `BUILD_DOCKER_IMAGE=1 ./setup.sh` を追記
- 2026-09-15: 動作確認（リポジトリを一時ディレクトリに複製し、`tasks/*` と
  `nix` / `sudo` / `docker` をスタブ化して `--hostname nishiyamanomacbook-pro` で実行）
  - デフォルト: docker 関連の実行が 0 件（ソケット待ち・ビルド・prune いずれも走らない）
  - `BUILD_DOCKER_IMAGE=1`: `docker buildx build --pull --file
devcontainer/Dockerfile.host ...` が実行されることを確認
- 2026-09-15: `devenv shell lint-all` pass（pre-commit 全項目 + nix flake check）
