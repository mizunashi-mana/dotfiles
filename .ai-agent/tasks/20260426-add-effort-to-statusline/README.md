# add-effort-to-statusline

## 目的・ゴール

`nix/programs/claude-code/statusline.sh` に Claude Code の reasoning effort（`/effort` で切り替え可能）を表示する。

## 背景

Claude Code の status line script に渡される JSON には `effort.level` フィールドが含まれており、現在の reasoning effort を取得できる（公式ドキュメント: https://code.claude.com/docs/en/statusline）。

- `effort.level`: `low` / `medium` / `high` / `xhigh` / `max`
- モデルが effort パラメータをサポートしていない場合は、フィールド自体が JSON に含まれない
- thinking 表示は今回不要（要件外）

過去のタスク `20260321-improve-statusline-layout` で「effort」表示を計画していたが未実装。当時は `output_style.name` を effort 代わりに表示する案だったが、現在は公式の `effort.level` フィールドが使えるためそちらを採用する。

## 実装方針

1. `statusline.sh` で `.effort.level` を jq で抽出（フィールドが無い場合は空）
2. 値が存在する場合のみ表示（モデル非対応時はサイレントに省略）
3. 表示位置は line2 の末尾（`ctx | 5h | 7d | model | effort`）
4. レベルごとに色分け:
   - `low`: GREEN
   - `medium`: GREEN
   - `high`: YELLOW
   - `xhigh`: YELLOW
   - `max`: RED
5. プレフィックスは付けず、レベル値のみを表示（例: `high`, `max`）

## 完了条件

- [x] `effort.level` を JSON から取得し、値が存在する場合のみ status line に表示される
- [x] 値が無い場合（フィールド absent）は status line から省略される
- [x] レベルごとに色分けされる
- [x] 既存の dir / branch / ctx / 5h / 7d / model 表示が壊れていない
- [x] pre-commit hooks（shellcheck / shfmt / prettier）が通る

## 作業ログ

- 2026-04-26: タスク開始
- 2026-04-26: `statusline.sh` に `effort.level` 取得処理を追加
- 2026-04-26: サンプル JSON で動作確認（effort あり/なし、low/high/max の各色）
- 2026-04-26: ユーザー要望で表示位置を line2 末尾に変更、`effort:` プレフィックスを除去
- 2026-04-26: `prek run` で shellcheck / shfmt / prettier 全 pass を確認
  - 注: `devenv shell lint-all` は upstream nixpkgs の prek patch が当たらず devenv shell 自体が起動できない環境問題があり、`prek run --files` で代替確認
