# 古くなったインストール方法・参照の見直し

## 目的

当時の事情で選んだインストール方法（Homebrew 経由・stable 固定・暫定フラグ）や古い参照のうち、事情が解消したものを今の標準のやり方に戻す。

## 方針

- helm: nixpkgs が 3.x だったため Homebrew で入れていた。nixpkgs unstable が 4.3.1（Homebrew と同じ）になったので `packages.pkgs.kubernetes-helm` に戻す。
- nix-darwin の flake input: リポジトリが `LnL7/nix-darwin` から `nix-darwin/nix-darwin` に移ったので URL を直す。
- Homebrew の `extraFlags = [ "--force-cleanup" ]`: ロック中の nix-darwin が `cleanup = "uninstall"` で自分で付けるようになったので削除する。
- direnv: stable（2.37.1）固定をやめ unstable（2.38.2）に戻す。
- VSCode の `ms-python.python`: unstable の debugpy がビルドに通る（キャッシュ済み）ので unstable に戻す。
- `tech.md` の nixpkgs-stable のバージョン表記（25.05 → 26.05）を直す。
- 残すもの: zotero（unstable 版は insecure な firefox-esr に依存）、ollama（MLX のため Homebrew）、texlive、mas。

## 完了条件

- [x] 上の変更が入っている
- [x] `devenv shell lint-all` が通る
- [x] macOS ホスト（nishiyamanomacbook-pro）の darwin 設定がビルドできる
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-10-29: 開始。nixpkgs unstable / stable / Homebrew のバージョンとバイナリキャッシュの有無を調べて対象を決めた
- 2026-10-29: 実装。lint-all が通り、nishiyamanomacbook-pro の darwin 設定がビルドできた（helm 4.3.1・direnv 2.38.2 が入り、`--force-cleanup` は nix-darwin が 1 回だけ付ける）
