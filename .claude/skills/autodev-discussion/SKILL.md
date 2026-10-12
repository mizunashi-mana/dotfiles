---
description: Interactively organize ideas, concerns, or vague thoughts through dialogue. Use when brainstorming, thinking through a problem, or wanting to clarify unclear ideas before taking action.
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, AskUserQuestion
---

# ディスカッション

「$ARGUMENTS」について、対話で考えを言語化・構造化する。ファイルの作成・編集はしない(ユーザーが明示的に頼んだときを除く)。

## 進め方

1. 何について考えたいのかをつかむ。不明瞭なら、どこが引っかかっているかを聞く。
2. 必要に応じて `.ai-agent/steering/`、コード、外部の情報を読み、根拠を持って話す。
3. 状況に応じて使い分ける。
   - 発散: ほかの方法や、制約が無かったらどうしたいかを問い、関連する事例を示す。
   - 収束: 要約して確かめ、論点とトレードオフを並べる。
   - 深掘り: 具体的な状況、そう感じる理由、前提と制約を明らかにする。
4. 区切りがついたら、明らかになったこと、決まっていないこと、次の一手(`/autodev-start-new-task`・`/autodev-start-new-survey`・`/autodev-start-new-project`・`/autodev-create-issue`)をまとめる。

結論を急がず、一方的に提案せず、問いかけでユーザー自身の考えを引き出す。
