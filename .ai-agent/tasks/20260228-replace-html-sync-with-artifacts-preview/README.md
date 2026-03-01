# replace-html-sync-with-artifacts-preview

## 目的・ゴール

mcp-html-sync-server を廃止し、@mizunashi_mana/mcp-html-artifacts-preview に置き換える。
新パッケージは同等のツール（create_page, update_page, destroy_page, add_scripts, add_stylesheets）に加え、
get_pages / get_page ツールを提供する。

## 実装方針

### mcp-html-sync-server の削除 → @mizunashi_mana/mcp-html-artifacts-preview の追加

1. `nix/node2nix/node-packages.json`: `"mcp-html-sync-server"` → `"@mizunashi_mana/mcp-html-artifacts-preview"`
2. `devenv shell node2nix-update` で node-packages.nix を再生成
3. `nix/packages/default.nix`: パッケージマッピングを更新
4. `nix/programs/mcp-html-sync-server/` → `nix/programs/mcp-html-artifacts-preview/` にリネームし内容を更新
5. `nix/programs/default-darwin.nix`: import パスを更新

### Claude Code 設定の更新

6. `nix/programs/claude-code/default.nix`:
   - 許可リストの `mcp__html-sync-server__*` を `mcp__html-artifacts-preview__*` に更新
   - 新ツール `get_pages`, `get_page` を許可リストに追加

### スキルファイルの更新

7. 4 つの autodev スキル + Nix 管理のテンプレートスキルで `html-sync` の参照を更新:
   - `.claude/skills/autodev-discussion/SKILL.md`
   - `.claude/skills/autodev-start-new-task/SKILL.md`
   - `.claude/skills/autodev-start-new-survey/SKILL.md`
   - `.claude/skills/autodev-start-new-project/SKILL.md`
   - `nix/programs/claude-code/skills/autodev-init/templates/skills/` 配下の対応テンプレート

## 完了条件

- [x] mcp-html-sync-server に関するすべての Nix 設定が削除されている
- [x] @mizunashi_mana/mcp-html-artifacts-preview が Nix パッケージとしてインストールされている
- [x] Claude Code の許可リストが新サーバーのツール名に更新されている（mcpServers の追加は対象外）
- [x] スキルファイルが新サーバー対応に更新されている
- [x] `devenv shell lint-all` が通る

## 作業ログ

- 2026-02-28: タスク開始
- 2026-02-28: 実装完了。mcp-html-sync-server を @mizunashi_mana/mcp-html-artifacts-preview に置き換え。許可リストに get_pages/get_page を追加
