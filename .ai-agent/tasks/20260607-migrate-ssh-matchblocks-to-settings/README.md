# programs.ssh.matchBlocks → programs.ssh.settings 移行

## 目的・ゴール

home-manager の SSH モジュールで `programs.ssh.matchBlocks` が deprecated になり、
`programs.ssh.settings` への移行が推奨されている。non-deprecated な API へ移行し、
ビルド時の warning を解消する。

## 背景・調査結果

home-manager の `modules/programs/ssh.nix`（locked: `b2b7db4`）を確認:

- `matchBlocks` は **deprecated alias for `settings`**（ssh.nix:744, 855）
- 内部で `matchBlocks` は `settings` に `mapAttrs` でそのまま移し替えられ、型・構造は同一（ssh.nix:779-785）
- `extraConfig` を使う場合は `settings."*"`（デフォルトホスト設定）の宣言が必須（ssh.nix:817-818）
- 現状の `matchBlocks."*" = {}` がこの条件を満たしているため、`settings."*" = {}` へ置き換えれば条件を維持できる

## 実装方針

`nix/programs/ssh/default.nix` の `matchBlocks` を `settings` にリネーム。挙動は不変。

```nix
programs.ssh = {
  enable = true;
  enableDefaultConfig = false;
  settings = {
    "*" = { };
  };
  extraConfig = builtins.readFile ./ssh.conf;
};
```

## 完了条件

- [x] `nix/programs/ssh/default.nix` を `settings` に移行
- [x] `devenv shell lint-all`（pre-commit + nix flake check）が通る
- [x] PR を作成（`/autodev-create-pr`） → https://github.com/mizunashi-mana/dotfiles/pull/284

## 作業ログ

- 2026-06-07: タスク開始。トリアージの結果そのまま続行（1ファイルのリネーム、短時間で完了する実装タスク）。home-manager SSH モジュールを調査し、`matchBlocks` → `settings` のリネームで移行可能と確認。
- 2026-06-07: `nix/programs/ssh/default.nix` の `matchBlocks` を `settings` にリネーム。`devenv shell lint-all` で `all checks passed!`。`homeConfigurations.desktop-62r22ok.config.warnings` が `[]` となり、matchBlocks deprecation warning の解消を確認。
