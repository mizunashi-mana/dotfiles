# argocd CLI の追加

## 目的・ゴール

dotfiles に Argo CD CLI (`argocd`) を追加する。Kubernetes への宣言的 CD を扱うため、
既に導入済みの `helm` と並ぶ k8s 系ツールとして利用する。

## バージョン調査結果

| ソース                               | バージョン | 備考                                    |
| ------------------------------------ | ---------- | --------------------------------------- |
| upstream 最新                        | 3.5.2      | 2026-08-27 リリース                     |
| nixpkgs unstable（本リポジトリ pin） | 3.4.6      | 2026-07-31 リリース版。3.4.x は保守対象 |
| nixpkgs master                       | 3.4.6      | 2026-08-04 に 3.4.5 → 3.4.6 で bump     |
| Homebrew                             | 3.5.2      | upstream に追従                         |

### メンテ状況

- nixpkgs パッケージ: `pkgs/by-name/ar/argocd/package.nix`、メンテナ 3 名
- bump 履歴は活発。3.4.x 系はリリースから数日〜1 週間で追従している
  - 3.4.6 (07-31 リリース) → nixpkgs 08-04 反映（4 日）
  - 3.4.5 (07-09 リリース) → nixpkgs 07-16 反映（7 日）
- 新しい 3.5 系マイナーへの追従はまだ（3.5.0 は 08-04 リリース）。
  ただし 3.4.x は Argo CD 側で保守されているリリースラインであり、
  CLI として実用上の問題はない
- `platforms` に `aarch64-darwin` / linux 各種を含む
- バイナリキャッシュ済み（`nix build --dry-run` で fetch のみ、ソースビルド不要）

### 判断

**nixpkgs unstable を採用する。**

nixpkgs 版は upstream の 1 マイナー遅れだが、保守対象のリリースライン上にあり、
パッケージ自体のメンテも活発。helm のようにメジャーバージョン遅れ（3.x vs 4.x）
ではないため、Homebrew に逃がす理由がない。リポジトリの方針どおり Nix 管理とする。

## 実装方針

`nix/programs/helm` と同じ粒度で新規モジュールを作成する。

1. `nix/programs/argocd/default.nix` を作成し、`packages.pkgs.argocd` を
   `home.packages` に追加する（`mcp-grafana` と同じ形）
2. `nix/programs/default-darwin.nix` の `programs` リストに
   `(import ./argocd { inherit packages; })` を追加する
   - helm と同様、対象は macOS のみとする（Linux ホストは devcontainer / デスクトップ用途）
3. `.ai-agent/structure.md` は `nix/programs/` を個別列挙していないため更新不要

## 完了条件

- [x] `nix/programs/argocd/default.nix` が作成されている
- [x] `nix/programs/default-darwin.nix` に argocd が登録されている
- [x] macOS 2 ホストで `argocd-3.4.6` が解決される / Linux ホストには入らない
- [x] `devenv shell lint-all` が通る
- [x] PR を作成（`/autodev-create-pr`） → https://github.com/mizunashi-mana/dotfiles/pull/306

## 作業ログ

- 2026-09-02: タスク開始。バージョン・メンテ状況調査完了、nixpkgs unstable 採用を決定
- 2026-09-02: `nix/programs/argocd/default.nix` を作成、`default-darwin.nix` に登録
- 2026-09-02: 導入結果を eval で検証
  - `nishiyamanomacbook-air`（user: mizunashi） → `argocd-3.4.6`
  - `nishiyamanomacbook-pro`（user: nishiyama-shun） → `argocd-3.4.6`
  - `desktop-62r22ok` → 未導入（darwin 限定の意図どおり）
- 2026-09-02: `devenv shell lint-all` pass（pre-commit 全項目 + nix flake check）
  - 補足: 新規ファイルが untracked のままだと flake がモジュールを認識せず
    検証が空振りするため、`git add` 後に再実行して確認した
- 2026-09-02: PR 作成 → https://github.com/mizunashi-mana/dotfiles/pull/306
