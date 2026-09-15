# ollama を Homebrew 管理に切り替えて MLX を有効化

## 目的・ゴール

ollama の MLX エンジン（Apple Silicon 向け Metal バックエンド）を使えるようにする。

現状の nixpkgs 版 ollama は MLX が無効化されており、overlay でも有効化できない。
Homebrew 版は MLX 有効なボトルを配布しているため、ollama のインストール経路を
nixpkgs（home-manager `services.ollama`）から Homebrew formula に移行する。

## 調査結果

### nixpkgs 版では MLX を有効化できない

nixpkgs の `pkgs/by-name/ol/ollama/package.nix:308` が MLX を明示的に無効化している。

```nix
cmake -B build \
  ...
  -DOLLAMA_MLX_BACKENDS="" \
```

実際、インストール済みバイナリのバックエンドは llama.cpp のみ。

```console
$ ls /nix/store/...-ollama-0.34.0/lib/ollama/
CPP_HTTPLIB_LICENSE  LLAMA_CPP_LICENSE  LLAMA_CPP_VENDORS_LICENSE
llama-quantize       llama-server
```

無効化の理由は、ollama 側の `cmake/local.cmake:28-52`（`ollama_check_metal_toolchain`）が
MLX Metal ビルドに **Xcode の Metal シェーダコンパイラ**を要求するため。

```
MLX Metal requires Xcode command line tools. Install Xcode, run
`sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`, then install
the Metal toolchain with `xcodebuild -downloadComponent MetalToolchain`.
```

`metal` コンパイラは Xcode 本体にのみ同梱され再配布不可のため、nixpkgs の apple-sdk には
含まれない。本マシンでも未検出。

```console
$ xcode-select -p
/nix/store/...-apple-sdk-14.4
$ xcrun -sdk macosx --find metal
error: tool 'metal' not found
```

nixpkgs には `mlx` / `mlx-c` パッケージも存在しない（`mlx42` / `mlxbf-*` は無関係）。
したがって overlay で `-DOLLAMA_MLX_BACKENDS=metal_v3` を渡してもビルドは通らない。

### Homebrew 版は MLX 有効

Homebrew は MLX 本体を別 formula `mlx-c`（ボトル済み）として持ち、ollama 本体は
Go のビルドタグだけでビルドする構成を取っている（`Formula/o/ollama.rb`）。

```ruby
depends_on "mlx-c" => :no_linkage   # macOS arm64 のみ

mlx_args << "-tags=mlx"
system "go", "build", *mlx_args, ...

# mlx runner は <exe_dir>/lib/ollama/mlx_*/ から dlopen する
(libexec/"lib/ollama/mlx_metal_v3").mkpath
ln_sf formula_opt_lib("mlx-c")/"libmlxc.dylib", libexec/"lib/ollama/mlx_metal_v3/libmlxc.dylib"
```

つまり Metal シェーダのコンパイルは `mlx-c` 側で完結しており、利用者はボトルを取得する
だけで済む。これが MLX を使える唯一の現実的な経路。

### バックエンドは metal_v3 になる

`ollama_default_mlx_backends`（`cmake/local.cmake:80-95`）は macOS と SDK が
ともに 26.2 以上なら `metal_v4`、それ以外は `metal_v3` を選ぶ。本マシンは
macOS 26.6.2 だが SDK は 14.4 のため `metal_v3`。Homebrew formula も
`mlx_metal_v3` 固定で symlink している。

### 選択肢の比較

| 経路                       | MLX | 備考                                       |
| -------------------------- | --- | ------------------------------------------ |
| nixpkgs（現状）            | ✗   | 上記のとおり有効化不可                     |
| Homebrew formula `ollama`  | ✓   | CLI 中心。`brew services` で常駐。**採用** |
| Homebrew cask `ollama-app` | ✓   | GUI アプリ同梱。auto_updates で nix 管理外 |

CLI 用途で現状の使い方に最も近い formula を採用する。

## 実装方針

1. `nix/programs/ollama/default.nix` を書き換える
   - home-manager の `services.ollama` を削除（nixpkgs 版パッケージと launchd agent
     `org.nix-community.home.ollama` が同時に入るとポート 11434 が競合するため）
   - `nix/programs/helm` と同じ形で `homebrew.brews` に移行する
   - 常駐は formula の `service` ブロック（`OLLAMA_FLASH_ATTENTION=1`,
     `OLLAMA_KV_CACHE_TYPE=q8_0`, `keep_alive`）に任せ、nix-darwin の
     `restart_service = "changed"` でログイン時登録 + 更新時再起動とする
2. `nix/programs/default-darwin.nix` の登録はそのまま（darwin 限定で変更なし）
3. `.ai-agent/steering/` / `structure.md` は `nix/programs/` を個別列挙していないため更新不要

## 完了条件

- [x] `nix/programs/ollama/default.nix` が `homebrew.brews` ベースになっている
- [x] home-manager 側から nixpkgs 版 ollama が外れている（macOS 2 ホストで eval 検証）
- [x] Linux ホストには影響しないことを確認
- [x] `devenv shell lint-all` が通る
- [x] PR を作成（`/autodev-create-pr`） → https://github.com/mizunashi-mana/dotfiles/pull/310

## 作業ログ

- 2026-09-15: タスク開始。トリアージの結果、調査は完了済みのため survey には回さず
  実装タスクとして続行。nixpkgs では MLX 有効化不可であることを確認し、
  Homebrew formula への移行方針をユーザー承認済み
- 2026-09-15: `nix/programs/ollama/default.nix` を `homeManagerImports` +
  `services.ollama` から `nixDarwinModules` + `homebrew.brews` に書き換え
- 2026-09-15: eval で導入結果を検証
  - Brewfile 行: `brew "ollama", restart_service: :changed, trusted: true`（macOS 2 ホストとも）
  - `services.ollama.enable` → `false`、home-manager の `home.path` に `bin/ollama` なし
  - launchd agent 一覧から `ollama` が消えた
    （残りは aerospace / emacs / git-maintenance-{daily,hourly,weekly}）
  - `nix/programs/default-darwin.nix` からのみ import されており Linux ホストは対象外
- 2026-09-15: `devenv shell lint-all` pass（pre-commit 全項目 + nix flake check）
- 2026-09-15: PR 作成 → https://github.com/mizunashi-mana/dotfiles/pull/310
