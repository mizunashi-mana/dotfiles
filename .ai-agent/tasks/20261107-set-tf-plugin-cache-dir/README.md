# TF_PLUGIN_CACHE_DIR を設定する

## 目的

Terraform / OpenTofu のプロバイダをプロジェクトをまたいで使い回し、`terraform init` のたびのダウンロードとディスクの消費を減らす。

## 方針

- 全ホスト共通の `nix/home-manager/home/default.nix` の `home.sessionVariables` に `TF_PLUGIN_CACHE_DIR = "${config.xdg.cacheHome}/terraform/plugin-cache"`（`~/.cache/terraform/plugin-cache`）を足す
- Terraform 本体はこのリポジトリでは入れておらず、各プロジェクトの devenv などで入れる前提。環境変数だけを全ホストに配る
- Terraform はキャッシュのディレクトリを自分では作らず、無いと init が失敗するので、`home.activation` で `mkdir -p` する
- `config` / `lib` を使うため、モジュールを `{ packages, default-editor, ... }: { config, lib, ... }: ...` の形にする

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `darwinConfigurations.nishiyamanomacbook-pro.system` がビルドでき、`hm-session-vars.sh` に `TF_PLUGIN_CACHE_DIR` が入っている
- [x] activation の中身が `run mkdir -p ~/.cache/terraform/plugin-cache` になっている
- [x] `homeConfigurations`（devcontainer / desktop-62r22ok）でも変数がそのホストのホーム配下になる
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-11-07: 開始
- 2026-11-07: 実装。lint-all が通り、nishiyamanomacbook-pro のビルドで `export TF_PLUGIN_CACHE_DIR="/Users/nishiyama-shun/.cache/terraform/plugin-cache"` を確かめた。devcontainer は `/home/vscode/...`、desktop-62r22ok は `/home/workuser/...` になる
