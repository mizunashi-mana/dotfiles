# hermes-agent を darwin-default に追加

## 目的・ゴール

[Nous Research の Hermes Agent](https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup) を darwin 環境（macbook-air / macbook-pro）に常にインストールされるようにする。

参照ドキュメント: https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup

## 前提・調査結果

- hermes-agent は flake (`github:NousResearch/hermes-agent`) として配布されており、`systems` に `aarch64-darwin` を含む
- ドキュメントは NixOS module (`hermes-agent.nixosModules.default`) を中心に説明しているが、darwin 用 module は提供されていない
- 本リポジトリの darwin ホストは macOS のため、NixOS module は適用不可。`packages.${system}.default`（=`hermes` CLI）を `home.packages` に入れて `hermes setup` / `hermes chat` を CLI として使える状態にすることをゴールとする
- secrets / MCP / container 設定はユーザーが `hermes setup` で対話的に行う運用に委ねる（前例: `mcp-grafana`、`github-mcp-server` も同様にパッケージ提供のみ）

## 実装方針

1. `flake.nix` に `hermes-agent` flake input を追加
   - `url = "github:NousResearch/hermes-agent"`
   - `inputs.nixpkgs.follows = "nixpkgs"`（unstable 系で揃える）
2. `nix/packages/default.nix`（または同等のパッケージエクスポート）から `inputs.hermes-agent.packages.${system}.default` を参照できるようにする
   - 既存の `claude-code` 等の参照方法を踏襲
3. `nix/programs/hermes-agent/default.nix` を新規作成
   - `home.packages` に hermes パッケージを追加するだけのシンプルな module
   - 前例: `nix/programs/agent-browser/default.nix`
4. `nix/programs/default-darwin.nix` の `programs` リストに `(import ./hermes-agent { inherit packages; })` を追加
5. `.ai-agent/structure.md` の差分が必要なら更新（既存の `default-darwin.nix` 説明には個別パッケージは載っていないので、たぶん不要）

## 完了条件

- [x] `flake.nix` に hermes-agent input がある
- [x] `nix/packages/` から hermes-agent パッケージが参照可能
- [x] `nix/programs/hermes-agent/default.nix` が存在する
- [x] `nix/programs/default-darwin.nix` に hermes-agent の import がある
- [x] `nix flake check` が通る
- [x] 両 darwin 設定（macbook-pro / macbook-air）の評価成功
- [x] `nix fmt -- --fail-on-change` で formatter clean
- [x] PR を作成（`/autodev-create-pr`） → https://github.com/mizunashi-mana/dotfiles/pull/273

## 作業ログ

- `flake.nix` に `hermes-agent` input を追加（`url = "github:NousResearch/hermes-agent"`、`inputs.nixpkgs.follows = "nixpkgs"`）
- `nix/packages/default.nix` に `hermes-agent = inputs.hermes-agent.packages.${system}.default;` を追加（前例: `claude-code`）
- `nix/programs/hermes-agent/default.nix` を新規作成（`home.packages` で `packages.hermes-agent` をインストール、前例: `agent-browser`）
- `nix/programs/default-darwin.nix` の programs リストに `(import ./hermes-agent { inherit packages; })` を追加
- `nix flake lock` で flake.lock を更新（hermes-agent 経由で pyproject-nix / uv2nix / pyproject-build-systems / npm-lockfile-fix が引き込まれる）
- 検証:
  - `nix flake check --no-build`: all checks passed
  - `darwinConfigurations.nishiyamanomacbook-air` 評価成功
  - `darwinConfigurations.nishiyamanomacbook-pro` 評価成功
  - `nix fmt -- --fail-on-change`: formatted 5 files (0 changed)
- 補足: hermes-agent ドキュメントの NixOS module（`services.hermes-agent`）は darwin では適用不可なため、CLI パッケージのみを `home.packages` で提供する方針とした。secrets / MCP / container 等の構成は `hermes setup` で対話的に行う運用
- PR: https://github.com/mizunashi-mana/dotfiles/pull/273
