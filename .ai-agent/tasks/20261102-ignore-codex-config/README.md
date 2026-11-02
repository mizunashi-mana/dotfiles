# git のグローバル ignore に .codex/config.toml を足す

## 目的

プロジェクトごとの Codex 設定（`.codex/config.toml`）を誤ってコミットしないよう、グローバルに無視する。

## 方針

- `nix/programs/git/conf.d/global.gitignore` の `# claude-code` セクションの直後に `# codex` セクションを足し、`.codex/config.toml` を書く
- `.codex/` ディレクトリごとではなく `config.toml` だけを対象にし、`.codex/` の他のファイル（共有したい skills など）は今までどおり管理できるようにする
- 既存の `.claude/*.local.json` と同じく、リポジトリのルート基準の書き方に揃える

## 完了条件

- [x] `git -c core.excludesFile=nix/programs/git/conf.d/global.gitignore check-ignore -v .codex/config.toml` で無視されることを確かめる
- [x] 同じ方法で `.codex/` 以下の他のファイルが無視されないことを確かめる
- [x] `devenv shell lint-all` が通る
- [ ] レビューを取り込み CI が通った PR →

## 作業ログ

- 2026-11-02: 開始
- 2026-11-02: `.codex/config.toml` が無視され、`.codex/other.toml`・`.codex/skills/foo/SKILL.md` は無視されないことを確かめた。サブディレクトリの `sub/.codex/config.toml` はルート基準の書き方なので対象外。lint-all が通った
