# Homebrew cleanup エラーの修正

## 背景

[nix-darwin#1787](https://github.com/nix-darwin/nix-darwin/issues/1787) で報告されている通り、Homebrew の
[commit e0d818b](https://github.com/Homebrew/brew/commit/e0d818bbbd6c7a28e336f2f89992ad696136d5d9)
以降、`brew bundle install --cleanup` は破壊的な cleanup を行う際に
`--force` / `--force-cleanup` / 環境変数 `$HOMEBREW_ASK` のいずれかを要求するようになった。

このリポジトリでは `nix/nix-darwin/homebrew/default.nix` で
`homebrew.onActivation.cleanup = "uninstall"` を設定しているため、
新しい Homebrew では system activation 時に cleanup が失敗する。

## 目的・ゴール

system activation 時の Homebrew cleanup エラーを解消し、`darwin-rebuild` が
正常に完了するようにする。

## 実装方針

upstream の修正 PR [nix-darwin#1789](https://github.com/nix-darwin/nix-darwin/pull/1789)
（`--force-cleanup` を付与する）はまだ未マージのため、issue で案内されている
ユーザー側ワークアラウンドを適用する。

`nix/nix-darwin/homebrew/default.nix` の `onActivation` に以下を追加する:

```nix
extraFlags = [
  "--force-cleanup"
];
```

これは PR #1789 と同等の効果（cleanup を確認なしで強制実行）を、
nix-darwin の `homebrew.onActivation.extraFlags` オプション経由で実現する。

upstream PR #1789 がマージされ flake input を bump した後は、この
ワークアラウンドを削除できる（その旨をコメントで残す）。

## 完了条件

- [x] `nix/nix-darwin/homebrew/default.nix` に `extraFlags = [ "--force-cleanup" ];` を追加
- [x] 削除可能な暫定対応であることが分かるコメントを残す
- [x] `devenv shell lint-all` が通る
- [x] PR を作成（`/autodev-create-pr`） → https://github.com/mizunashi-mana/dotfiles/pull/283

## 作業ログ

- トリアージ: ゴールが明確で 1 ブランチ・1 PR で完結する小規模な設定修正のため、
  `/autodev-start-new-task` のまま続行と判断。
- 原因調査: issue #1787 / PR #1789 を確認。Homebrew commit e0d818b 以降 cleanup に
  `--force-cleanup` 等が必要。upstream PR は未マージ。issue コメントで
  `homebrew.onActivation.extraFlags = ["--force-cleanup"]` のワークアラウンドが案内されている。
- 実装: `nix/nix-darwin/homebrew/default.nix` の `onActivation` に `extraFlags = [ "--force-cleanup" ];`
  を追加し、暫定対応の旨をコメントで明記。
- 検証: `devenv shell lint-all` が通過（pre-commit 全 hook + nix flake check）。
  `darwinConfigurations` の評価も成功し、pinned 版 nix-darwin に `extraFlags` オプションが
  存在することを確認。
