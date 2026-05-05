# mizunashi-agent-skills を最新にアップデート

## 目的・ゴール

`flake.lock` 内の `mizunashi-mana-skills` を最新コミットに更新し、
agent-coach umbrella スキル廃止に伴う設定変更に追従する。

## 背景

- 現在 pin されている revision: `ec133806094c2a306d2fdbc6e96eb228e909b4dc` (2026-04-27)
- 最新 revision: `d5d4c1bec93eadc68dcb1615375365d86192458e`
- 差分: 20 commits

主要な変更点:

- **agent-coach umbrella スキル削除** (PR #14, commit `73d6c43`)
  以下 5 つの split skill に置き換え:
  - `detect-context-rot`
  - `detect-token-hotspots`
  - `detect-rework-and-violations`
  - `detect-missed-skill-triggers`
  - `recommend-bash-allowlist`
- autodev / merge-dependabot-bump-pr プラグインに機能差分なし

## 実装方針

1. `nix flake update mizunashi-mana-skills` で `flake.lock` を更新
2. `nix/programs/agent-skills-mizunashi-mana/default.nix` の `enable` リストから
   `"agent-coach"` を削除し、5 つの split skill 全てを有効化する
3. `.ai-agent/structure.md` の `agent-skills-mizunashi-mana/` 説明文を新構成に追従
4. `devenv shell lint-all` で全ホスト構成が build できることを確認

## 完了条件

- [x] `flake.lock` の `mizunashi-mana-skills` が最新 revision を指す
- [x] `agent-skills-mizunashi-mana/default.nix` から `"agent-coach"` が消え、
      5 つの split skill が enable されている
- [x] `.ai-agent/structure.md` の記述が新構成と一致
- [x] lint チェック (prek) が成功 + darwin host build が成功
- [x] PR 作成: https://github.com/mizunashi-mana/dotfiles/pull/267

## 作業ログ

- 2026-05-06: タスク開始。flake.lock 更新と split skill への移行が必要なことを確認。
- 2026-05-06: `nix flake update mizunashi-mana-skills` で revision を `d5d4c1b` に更新。
- 2026-05-06: `agent-skills-mizunashi-mana/default.nix` の `enable` リストを
  `agent-coach` umbrella の代わりに 5 つの split skill (alphabetical) に置換。
- 2026-05-06: `structure.md` の skill 列挙を新構成に合わせて更新。
- 2026-05-06: 動作確認:
  - `nix flake check --no-build`: all checks passed
  - `nix build .#darwinConfigurations.{air,pro}.system`: 成功
    - bundle 内に 7 skill (autodev-init / detect-\* x4 / merge-dependabot-bump-pr / recommend-bash-allowlist) + skill-creator が出力されることを確認
  - Linux ホスト build は platform mismatch (master でも同様) のためスキップ
  - `prek run`: nixfmt / prettier 含め変更ファイル全て Passed
  - `devenv shell lint-all` は devenv-nixpkgs のパッチ失敗で実行不可（環境側の問題で本変更とは無関係）
