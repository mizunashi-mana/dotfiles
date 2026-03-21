# improve-statusline-layout

## 目的・ゴール

`nix/programs/claude-code/statusline.sh` の表示を改善する。

## 実装方針

1. ディレクトリ表示: 通常は basename のみ。`project_dir` と `current_dir` が異なる場合は相対パスを表示し、長い場合は改行で分離
2. ブランチ名: 長すぎる場合は truncate（末尾 `…`）
3. 並び順変更: dir | branch | effort | ctx | 5h | 7d | model（モデル名を最後に移動）
4. output_style.name を effort として表示追加

## 完了条件

- [ ] ディレクトリ表示が basename / 相対パス切り替えで動作する
- [ ] ブランチ名の truncation が動作する
- [ ] output_style.name が表示される
- [ ] モデル名が最後に表示される
- [ ] `devenv shell lint-all` が通る

## 作業ログ

- 2026-03-21: タスク開始
