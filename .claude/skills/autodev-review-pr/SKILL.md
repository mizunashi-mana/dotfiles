---
description: Review a GitHub pull request with a reviewer subagent in a clean context and post the result as a GitHub review. Use after creating a PR, or when asked for an unbiased review without the current conversation's context influencing it.
allowed-tools: Read, "Bash(git branch --show-current)", "Bash(gh pr list *)", "Bash(gh pr view *)", Agent, AskUserQuestion, Skill(autodev-import-review-suggestions)
---

# PR のレビュー

PR「$ARGUMENTS」を、今の会話の文脈を持たない reviewer に見させる。

## 1. 対象の特定

- `$ARGUMENTS` に番号か URL があればそれを使う。
- 無ければ `gh pr list --head $(git branch --show-current) --json number,url --limit 1` で探す。見つからなければユーザーに聞く。

## 2. reviewer の起動

同じディレクトリの [reviewer-prompt.md](reviewer-prompt.md) を読み、`{PR_NUMBER}` を置き換えて Agent に渡す。

```
Agent({
  description: "Review PR #{PR番号}",
  subagent_type: "general-purpose",
  prompt: "<reviewer-prompt.md の内容>"
})
```

会話で分かっている意図や事情をプロンプトに足さない。PR の本文とコードだけから読めるかを見るため。

## 3. 報告

- reviewer の結果(指摘の件数と中身、推奨アクション、投稿したレビューの URL)をユーザーに伝える。
- `/autodev-start-new-task` から呼ばれたときは、指摘の取り込みは `/autodev-start-new-task` が続けて行う。
- 単独で呼ばれて指摘があれば、`/autodev-import-review-suggestions <PR番号>` で取り込みに進む。
