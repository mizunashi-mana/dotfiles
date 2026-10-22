# AGENTS.md への移行とパッケージ更新

## 目的

Claude Code 専用だったエージェント設定を、Codex などほかのエージェントとも共有できる `AGENTS.md` / `.agents/skills` に一本化する。あわせて `update-pkgs` による更新を、ビルドが通る状態で取り込む。

## 方針

1. `AGENTS.md` を正本にし、`CLAUDE.md` は消す
2. `.agents/skills` を正本にし、`.claude/skills` は `../.agents/skills` へのシンボリックリンクにする
3. `.agents/skills` の機械的な置換ミス（`.Codex/skills/`、「built into Codex」）を、どのエージェントにも通じる書き方に直す
4. `structure.md` と `tech.md` の `CLAUDE.md` / `.claude/skills` の記述を更新する
5. `flake.lock` を更新する。hermes-agent は最新版（ebc9960）がビルドに失敗するため、前の 4e745c5 に固定する。aws-sam-cli は新しい nixpkgs でテストが落ちる（click の更新が原因とみられる）ため、`pkgs-stable` から入れる。npm の package-lock も更新する

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `nishiyamanomacbook-pro` と `nishiyamanomacbook-air` の darwin 設定がビルドできる
- [x] Claude Code から autodev スキルが見える
- [ ] レビューを取り込み CI が通った PR → <URL>

## 作業ログ

- 2026-10-22: 開始。CLAUDE.md は残さず消す方針でユーザーと合意
- 2026-10-22: lint-all と Pro・Air のビルドが通ることを確かめた。Claude Code 2.1.307 で、CLAUDE.md が無くても AGENTS.md が読み込まれ、`.claude/skills` のシンボリックリンク経由で autodev スキルが見えることを確かめた
