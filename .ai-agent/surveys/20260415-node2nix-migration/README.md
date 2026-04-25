# node2nix からの脱却可能性調査

## 調査の問い

- 現在 node2nix で管理している 5 つの npm パッケージを、nixpkgs や他の手段に移行できるか
- 移行後、node2nix 関連のコード・ツールを完全に削除できるか

## 背景

node2nix は Node.js パッケージを Nix で管理するためのツールだが、以下の問題がある:

- 生成ファイル（`node-packages.nix`, `node-env.nix`）が大きく、差分レビューが困難
- `nodejs_14` をベースにしており古い
- 依存更新のたびに `node2nix-update.sh` の実行が必要
- nixpkgs に同等パッケージがあれば不要

## 調査方法

- nixpkgs unstable での各パッケージの有無を `nix eval` / `nix search` で確認
- node2nix 生成コードのパッケージソース（npm registry）を確認
- 各 programs モジュールの利用状況を確認

## 調査結果

### パッケージ別の移行可能性

| パッケージ                                   | node2nix バージョン | nixpkgs での状況                        | 移行方針                       |
| -------------------------------------------- | ------------------- | --------------------------------------- | ------------------------------ |
| `@openai/codex`                              | 最新                | `nixpkgs#codex` (v0.118.0) あり         | nixpkgs に移行可能             |
| `@playwright/mcp`                            | 最新                | `nixpkgs#playwright-mcp` (v0.0.56) あり | nixpkgs に移行可能             |
| `@playwright/cli`                            | v0.1.7              | nixpkgs に直接対応なし                  | 要検討（後述）                 |
| `@mizunashi_mana/cc-voice-reporter`          | v2.2.0              | nixpkgs になし（個人パッケージ）        | `buildNpmPackage` で自前ビルド |
| `@mizunashi_mana/mcp-html-artifacts-preview` | v1.0.0              | nixpkgs になし（個人パッケージ）        | `buildNpmPackage` で自前ビルド |

### 詳細分析

#### @openai/codex → nixpkgs#codex

- nixpkgs に `codex` (v0.118.0) として存在
- Home Manager に `programs.codex` モジュールもあり、現在の `codex/default.nix` で既に使用中
- `package = packages.node-packages."@openai/codex"` を `package = packages.pkgs.codex` に変更するだけ

#### @playwright/mcp → nixpkgs#playwright-mcp

- nixpkgs に `playwright-mcp` (v0.0.56) として存在
- `/bin/mcp-server-playwright` が含まれる
- 現在の `playwright-mcp/default.nix` ではバイナリパスを `"${playwright-mcp}/bin/playwright-mcp"` として参照
- nixpkgs 版は `mcp-server-playwright` という名前なのでパスの調整が必要

#### @playwright/cli — 要検討

- nixpkgs には直接対応するパッケージがない
- `playwright-driver` は node モジュールのみ（CLI ラッパーなし）
- 用途: Playwright ブラウザのインストール・管理用 CLI
- 選択肢:
  1. `buildNpmPackage` で自前ビルド
  2. nixpkgs の `playwright-driver.browsers` を直接使う（ブラウザバイナリ）
  3. playwright-mcp が内部で playwright を同梱しているならそちらに任せる

#### @mizunashi_mana/cc-voice-reporter, @mizunashi_mana/mcp-html-artifacts-preview

- 個人の npm パッケージ（npm registry で公開済み）
- `pkgs.buildNpmPackage` で npm registry からビルドする形に移行可能
- `fetchurl` + `buildNpmPackage` パターンで `nix/packages/` にパッケージ定義を追加する

### buildNpmPackage について

nixpkgs の `buildNpmPackage` は node2nix の代替として推奨されているビルダー:

- `npm install` + `npm pack` ベースでビルド
- `npmDepsHash` で依存関係をロック（再現性あり）
- node2nix のような巨大な生成ファイルが不要
- nodejs バージョンも自由に指定可能

## 結論

### 移行可能性: 全パッケージ移行可能、node2nix 完全削除できる

#### 推奨移行プラン

**フェーズ 1（簡単）: nixpkgs 既存パッケージへの切り替え**

- `@openai/codex` → `packages.pkgs.codex`
- `@playwright/mcp` → `packages.pkgs.playwright-mcp`（バイナリ名の調整あり）

**フェーズ 2（中程度）: buildNpmPackage での自前ビルド**

- `@mizunashi_mana/cc-voice-reporter` → `buildNpmPackage` で定義
- `@mizunashi_mana/mcp-html-artifacts-preview` → `buildNpmPackage` で定義

**フェーズ 3（要検討）: @playwright/cli の代替**

- ブラウザインストールの仕組みを確認し、最適な方法を決定

**フェーズ 4: クリーンアップ**

- `nix/node2nix/` ディレクトリ削除
- `nix/packages/default.nix` から node2nix 参照を削除
- `devenv.nix` から node2nix 関連スクリプト削除
- `script/node2nix-update.sh` 削除
- `.ai-agent/steering/tech.md` から node2nix 記載を更新

### リスク・注意点

- `buildNpmPackage` の `npmDepsHash` は依存更新のたびに再計算が必要
- カスタムパッケージの `buildNpmPackage` 化は初回のハッシュ取得に試行錯誤が必要
- `@playwright/cli` は代替検討に追加調査が必要

## 参考リンク

- nixpkgs manual: buildNpmPackage — https://nixos.org/manual/nixpkgs/stable/#javascript-buildNpmPackage
