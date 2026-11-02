# git のグローバル ignore に .codex/config.toml を足す

## 目的

プロジェクトごとの Codex 設定（`.codex/config.toml`）を誤ってコミットしないよう、グローバルに無視する。

## 方針

- `nix/programs/git/conf.d/global.gitignore` の `# claude-code` セクションの直後に `# codex` セクションを足し、`.codex/config.toml` を書く
- `.codex/` ディレクトリごとではなく `config.toml` だけを対象にし、`.codex/` の他のファイル（共有したい skills など）は今までどおり管理できるようにする
- 既存の `.claude/*.local.json` と同じく、リポジトリのルート基準の書き方に揃える
- グローバル ignore はすべてのリポジトリに効くので、`.codex/config.toml` をコミットして共有しているリポジトリで新しく足すときは `git add -f` が要る。既に追跡されているファイルには影響しない。個人の設定を誤ってコミットしないことを優先して、この割り切りを受け入れる

## 完了条件

- [x] `git -c core.excludesFile=nix/programs/git/conf.d/global.gitignore check-ignore -v --no-index .codex/config.toml` で無視されることを確かめる
- [x] 同じ方法で `.codex/` 以下の他のファイルが無視されないことを確かめる
- [x] `devenv shell lint-all` が通る
- [x] レビューを取り込み CI が通った PR → https://github.com/mizunashi-mana/dotfiles/pull/334

## 作業ログ

- 2026-11-02: 開始
- 2026-11-02: `.codex/config.toml` が無視され、`.codex/other.toml`・`.codex/skills/foo/SKILL.md` は無視されないことを確かめた。サブディレクトリの `sub/.codex/config.toml` はルート基準の書き方なので対象外。lint-all が通った
- 2026-11-02: PR #334 を作成。レビューは Critical 0 / Warning 0 / Info 1（細かい点 1 つを含む）。どちらも取り込んだ
  - Info（共有用の `.codex/config.toml` も無視される割り切りを書いておく）: 方針に、足すときは `git add -f` が要ることと、それを受け入れる理由を書いた
  - 細かい点（完了条件のコマンドに `--no-index` が無い）: 実際に走らせたコマンドに合わせて足した
