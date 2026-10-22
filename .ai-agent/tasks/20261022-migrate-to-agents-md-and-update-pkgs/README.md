# AGENTS.md への移行とパッケージ更新

## 目的

Claude Code 専用だったエージェント設定を、Codex などほかのエージェントとも共有できる `AGENTS.md` / `.agents/skills` に一本化する。あわせて `update-pkgs` による更新を、ビルドが通る状態で取り込む。

## 方針

1. `AGENTS.md` を正本にし、`CLAUDE.md` は消す
2. `.agents/skills` を正本にし、`.claude/skills` は `../.agents/skills` へのシンボリックリンクにする
3. `.agents/skills` の機械的な置換ミス（`.Codex/skills/`、「built into Codex」）を、どのエージェントにも通じる書き方に直す
4. `structure.md` と `tech.md` の `CLAUDE.md` / `.claude/skills` の記述を更新する
5. `flake.lock` を更新する。hermes-agent は最新版（ebc9960）がビルドに失敗するため、前の 4e745c5 に固定する。aws-sam-cli は新しい nixpkgs でテストが落ちる（click の更新が原因とみられる）ため、`pkgs-stable` から入れる。npm の package-lock も更新する
   - hermes-agent は `flake.nix` では固定しない（最新を追う）。次の `update-pkgs` で上がるので、そのときにビルドが通るかを確かめ、まだ落ちるならまた前の rev に戻す

## 完了条件

- [x] `devenv shell lint-all` が通る
- [x] `nishiyamanomacbook-pro` と `nishiyamanomacbook-air` の darwin 設定がビルドできる
- [x] Claude Code から autodev スキルが見える
- [x] レビューを取り込み CI が通った PR → https://github.com/mizunashi-mana/dotfiles/pull/324

## 作業ログ

- 2026-10-22: 開始。CLAUDE.md は残さず消す方針でユーザーと合意
- 2026-10-22: lint-all と Pro・Air のビルドが通ることを確かめた。Claude Code 2.1.307 で、CLAUDE.md が無くても AGENTS.md が読み込まれ、`.claude/skills` のシンボリックリンク経由で autodev スキルが見えることを確かめた
- 2026-10-22: PR #324 を作成。レビューは Critical 0 / Warning 0 / Info 2。どちらも取り込んだ
  - Info 1（aws-sam-cli を pkgs-stable にした理由がコードに無い）: `nix/programs/awscli/default.nix` に理由と戻す条件をコメントで足した
  - Info 2（hermes-agent が次の `update-pkgs` で上がる）: 方針どおり `flake.nix` では固定せず、次の更新でビルドを確かめることを方針に書き足した
