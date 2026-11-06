# TF_PLUGIN_CACHE_DIR を設定する

## 目的

Terraform / OpenTofu のプロバイダをプロジェクトをまたいで使い回し、`terraform init` のたびのダウンロードとディスクの消費を減らす。

## 方針

- 全ホスト共通の `nix/home-manager/home/default.nix` の `home.sessionVariables` に `TF_PLUGIN_CACHE_DIR = "${config.xdg.cacheHome}/terraform/plugin-cache"`（`~/.cache/terraform/plugin-cache`）を足す
- Terraform 本体はこのリポジトリでは入れておらず、各プロジェクトの devenv などで入れる前提。環境変数だけを全ホストに配る
- Terraform はキャッシュのディレクトリを自分では作らず、無いと init が失敗するので、`home.activation` で `mkdir -p` する
- Terraform 1.4 以降は、依存ロックファイルにまだ載っていないプロバイダはキャッシュにあってもダウンロードし直す（`TF_PLUGIN_CACHE_MAY_BREAK_DEPENDENCY_LOCK_FILE` で変えられる）。新しいプロジェクトの最初の `init` では効かないが、ロックファイルの checksum を崩さないことを優先して既定のままにする
- `config` / `lib` を使うため、モジュールを `{ packages, default-editor, ... }: { config, lib, ... }: ...` の形にする

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `darwinConfigurations.nishiyamanomacbook-pro.system` がビルドでき、`hm-session-vars.sh` に `TF_PLUGIN_CACHE_DIR` が入っている
- [x] activation の中身が `run mkdir -p ~/.cache/terraform/plugin-cache` になっている
- [x] `homeConfigurations`（devcontainer / devcontainer-claude / desktop-62r22ok）でも変数がそのホストのホーム配下になる
- [x] レビューを取り込み CI が通った PR → https://github.com/mizunashi-mana/dotfiles/pull/338

## 作業ログ

- 2026-11-07: 開始
- 2026-11-07: 実装。lint-all が通り、nishiyamanomacbook-pro のビルドで `export TF_PLUGIN_CACHE_DIR="/Users/nishiyama-shun/.cache/terraform/plugin-cache"` を確かめた。devcontainer は `/home/vscode/...`、desktop-62r22ok は `/home/workuser/...` になる
- 2026-11-07: PR #338 を作成。レビューは Critical 0 / Warning 0 / Info 3
  - Info 1（ロックファイルに無いプロバイダはキャッシュが効かない）: 方針に既定のままにする理由と合わせて書いた
  - Info 2（キャッシュの並行利用は安全が保証されていない）: 直さない。手元で複数の init を同時に走らせる使い方はしておらず、困ったときにプロジェクト側で外せば足りる
  - Info 3（devcontainer-claude を確かめていない）: 評価し、`/home/vscode/.cache/terraform/plugin-cache` になり activation も入っていることを確かめた
