# setup.sh で古い Nix の世代を消す

## 目的

`setup.sh` の最後の掃除は `nix store gc` だけで、古い世代から参照されるパスが残り続けていた（nix-darwin の system 世代が 117 個たまり、`/nix/store` が 124G になっていた）。`setup.sh` を走らせるたびに古い世代を消し、`/nix/store` が増え続けないようにする。

## 方針

- `SKIP_CLEAN` が空のときの掃除を、次の順で行う
  1. `nix-collect-garbage --delete-older-than "$CLEAN_OLDER_THAN"` で古い世代を消す。darwin では nix-darwin の system 世代が root の profile なので `sudo` をつける
  2. `nix store gc` で参照されていないパスを消す
  3. `nix store optimise` で同じ中身のファイルをハードリンクにまとめる
- 環境変数 `CLEAN_OLDER_THAN`（既定は `40d`）で残す期間を変えられるようにし、`usage` に書く

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `SKIP_CLEAN=1` で掃除を飛ばす動きは変わらない（条件の書き方を変えていない）
- [x] レビューを取り込み CI が通った PR → https://github.com/mizunashi-mana/dotfiles/pull/327

## 作業ログ

- 2026-10-29: 開始
- 2026-10-29: setup.sh の掃除に古い世代の削除と `nix store optimise` を足した。lint-all は通った。実機での setup.sh の通しは sudo と switch を伴うため、マージ後の実行で確かめる
- 2026-10-29: PR #327 を作りレビューした。Critical・Warning は無し。Info 3 件はどれも直さない（`nix store gc` の重なりと darwin での `nix store optimise` はユーザーの希望で明示的に走らせる。darwin でユーザーの profile を掃除しない点は、home-manager が nix-darwin 経由でユーザーの profile を使っていないため）
