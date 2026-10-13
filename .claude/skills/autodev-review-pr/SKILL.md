---
description: Review a GitHub pull request with a reviewer subagent in a clean context and post the result as a GitHub review (review only, no fixes). Use after creating a PR, or when you want an unbiased code review without the current conversation's context influencing it.
allowed-tools: Read, Glob, Grep, WebSearch, AskUserQuestion, Agent, "Bash(git branch --show-current)", "Bash(git status *)", "Bash(gh pr list *)", "Bash(gh pr view *)", "Bash(gh pr diff *)", "Bash(gh api *)"
---

# PR のレビュー

PR「$ARGUMENTS」を、今の会話の文脈を持たない reviewer に見させる。このスキルはレビューだけを行い、直さない。

## 1. 対象の特定

- `$ARGUMENTS` に番号か URL があればそれを使う。
- 無ければ `gh pr list --head $(git branch --show-current) --json number,url --limit 1` で探す。見つからなければユーザーに聞く。
- `git status --short --branch --untracked-files=no` で、未コミットの変更や未プッシュのコミット（`[ahead N]`）が無いかを確かめる。あればレビューする差分とずれるので、先にコミット・プッシュするかを聞く。

## 2. reviewer の起動

同じディレクトリの [reviewer-spawn-prompt.md](reviewer-spawn-prompt.md) を読み、`{PR_NUMBER}` を置き換えて Agent に渡す。

```
Agent({
  description: "Review PR #{PR番号}",
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "<reviewer-spawn-prompt.md の内容>"
})
```

- 会話で分かっている意図や事情をプロンプトに足さない。PR の本文とコードだけから読めるかを見るため。
- Agent がバックグラウンドで走ったときは、完了の通知が届くまで結果を推測せずに待つ。

## 3. 報告

- reviewer の結果（指摘の件数と中身、推奨アクション、投稿したレビューの URL）をユーザーに伝える。
- `/autodev-start-task` から呼ばれたときは、指摘の取り込みは `/autodev-start-task` が続けて行う。
- 単独で呼ばれて指摘があれば、どれを直すかをユーザーに聞く。直すときは同じブランチでコミットしてプッシュし、行コメントのスレッドに返信して解決する。
