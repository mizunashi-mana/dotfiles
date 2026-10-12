---
description: Create a GitHub pull request following this project's conventions (PR template, Japanese title and body, branch policy). ALWAYS invoke this skill before running `gh pr create` — do NOT bypass it with the generic PR creation flow built into Claude Code. Use whenever changes on a feature branch are ready for review, or to update the body of the branch's existing PR.
allowed-tools: Read, "Bash(git status *)", "Bash(git log *)", "Bash(git diff *)", "Bash(git push *)", "Bash(git branch --show-current)", "Bash(gh pr list *)", "Bash(gh pr view *)", "Bash(gh pr create *)", "Bash(gh pr edit *)"
---

# PR の作成

今のブランチから PR を作る。

## 1. 状態の確認

- `git branch --show-current` が `master` なら止めて、ユーザーに伝える。
- `git status` で未コミットの変更が無いかを確かめる。あればコミットするかを聞く。
- `gh pr list --head <ブランチ> --json number,url` で既に PR があるかを確かめる。あれば本文の更新(`gh pr edit <番号> --body-file -`)だけにする。
- `git log origin/master..HEAD --oneline` と `git diff origin/master...HEAD --stat` で、入る変更をつかむ。

## 2. プッシュ

`git push -u origin <ブランチ>`

## 3. 作成

- タイトル: 日本語で変更を要約する。50 文字以内を目安にする。
- 本文は `.github/PULL_REQUEST_TEMPLATE.md` の見出しに沿って書き、ヒアドキュメントで渡す(改行が `\n` のまま残らないように)。

<!-- pr-language: ja -->

```bash
gh pr create --title "<タイトル>" --body-file - <<'BODY'
## 目的

何をなぜ変えるか。

## 変更概要

- 主な変更
- 確かめたこと(走らせた lint・ビルドと結果。確かめられなかったことも書く)
BODY
```

<!-- /pr-language -->

## 4. 確認と報告

- `gh pr view <番号> --json title,body` で本文が崩れていないかを確かめる。崩れていたら `gh pr edit <番号> --body-file -` で直す。
- PR の URL をユーザーに伝える。
