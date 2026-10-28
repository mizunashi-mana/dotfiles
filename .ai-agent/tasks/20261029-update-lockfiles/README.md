# ロックファイルの更新（2026-10-29）

## 目的

`update-pkgs` と `devenv update` による更新を、ビルドが通る状態で取り込む。

## 方針

1. `flake.lock`・`devenv.lock`・`nix/packages/node-pkgs/mcp-html-artifacts-preview/package-lock.json` の更新をそのまま取り込む
2. ビルドが落ちるものは、前回と同じく前の rev に固定するか `pkgs-stable` から入れる
3. 前回 4e745c5 に戻した hermes-agent は今回 780d5a3 に上がるので、ビルドが通るかを確かめる

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `nishiyamanomacbook-pro` と `nishiyamanomacbook-air` の darwin 設定がビルドできる
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-10-29: 開始
- 2026-10-29: lint-all と Pro・Air のビルドが通ることを確かめた。hermes-agent は 780d5a3 でビルドが通ったので、固定や回避は要らなかった
