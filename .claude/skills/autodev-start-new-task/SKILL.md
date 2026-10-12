---
description: Triage a development request and carry it out on a new branch until its PR has been reviewed, the review findings are addressed, and CI passes. Use when starting a feature, bug fix, or improvement; routes to discussion, survey, or project skills when the request is vague, needs investigation first, or spans multiple PRs.
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, "Bash(git status *)", "Bash(git fetch *)", "Bash(git switch *)", "Bash(git add *)", "Bash(git commit *)", "Bash(git diff *)", "Bash(git log *)", "Bash(git push *)", "Bash(git merge *)", "Bash(git rev-parse *)", "Bash(devenv shell lint-all)", "Bash(gh pr view *)", "Bash(gh pr checks *)", "Bash(gh run list *)", "Bash(gh run view *)", "Bash(gh api graphql *)", Skill(autodev-create-pr), Skill(autodev-review-pr), Skill(autodev-import-review-suggestions), Skill(autodev-discussion), Skill(autodev-start-new-survey), Skill(autodev-start-new-project)
---

# タスクの開始

「$ARGUMENTS」を仕分けし、1 ブランチ・1 PR で進める。

**ゴールは、レビュー結果を取り込んだ PR を作ること。** `/autodev-review-pr` の指摘をすべて直すか直さない理由を PR に書き、レビューのスレッドをすべて解決し、最後のプッシュの CI が通った時点で完了とする。方針の確認(手順 3)の後は、方針に関わる判断が出てこない限りユーザーに聞かずに進める。

## 1. 仕分け

| 状態                                   | 行き先                       |
| -------------------------------------- | ---------------------------- |
| 要件があいまいで、方向性の整理が要る   | `/autodev-discussion`        |
| やり方が分からない・比べてから決めたい | `/autodev-start-new-survey`  |
| 複数の PR に分けないと進まない         | `/autodev-start-new-project` |
| ゴールと完了条件が書け、1 PR で収まる  | このまま続ける               |

別のスキルに回すときは、理由と行き先をユーザーに示し、同意を得てから切り替える。

## 2. 下調べ

- `.ai-agent/steering/tech.md` と `.ai-agent/structure.md` のうち、関係するところを読む。
- 触るコードと、その周りの既存の書き方を確かめる。
- `.ai-agent/projects/` のタスクなら、プロジェクトの README で依存タスクが終わっているかを確かめる。

## 3. 方針の確認

目的・方針・完了条件(確かめ方を含む)・ブランチ名(kebab-case)をユーザーに示し、確認を取る。取れたら `.ai-agent/tasks/YYYYMMDD-<ブランチ名>/README.md` に書く。

```markdown
# <タスク名>

プロジェクト: <.ai-agent/projects/ の README へのリンク。無ければ省く>

## 目的

## 方針

## 完了条件

- [ ] ...
- [ ] レビューを取り込んだ PR → <URL>

## 作業ログ

- YYYY-MM-DD: 開始
```

途中で方針が変わったら README を直し、作業ログに理由を残す。文脈が切れても README から再開できるようにする。

## 4. 実装

1. `git status` で未コミットの変更が無いことを確かめる。あれば前のタスクのものかもしれないので、ユーザーに伝えて止める。
2. `git fetch origin` の後、`git switch --no-track -c <ブランチ名> origin/master` でブランチを作る。前のタスクのマージ前のコミットが入らないよう、必ず `origin/master` を起点にする。
3. TodoWrite で作業を分け、1 つずつ進める。
4. 区切りごとに `devenv shell lint-all` で確かめる。Nix の変更は、関係するホストの設定がビルドできるかも確かめる。
5. 意味のまとまりでコミットする。

## 5. 完了

1. 完了条件を満たしているか確かめる。満たせなかったものは隠さずに挙げる。
2. README の完了条件と作業ログを更新し、実装とまとめてコミットする。
3. `/autodev-create-pr` で PR を作る。
4. `/autodev-review-pr` でレビューする。
5. `/autodev-import-review-suggestions <番号>` で指摘を取り込む(直す・スレッドに返信する・解決する)。このスキルから呼ぶときは次に従う。
   - Critical と Warning は直す。Info は妥当なものを直す。方針に関わるものだけユーザーに聞く。
   - PR の本文とずれたら `/autodev-create-pr` で本文を更新する。
6. Critical を直したときは `/autodev-review-pr` をもう一度走らせる。2 回目でも Critical が残るときは、止めてユーザーに相談する。
7. `/autodev-import-review-suggestions` のスレッドの一覧を取り直し、未解決のスレッドが無いことを確かめる。返し忘れなら 5 に戻る。人間のレビュアーの判断を待っているスレッドは残してよく、報告で挙げる。
8. README の最後の完了条件に PR の URL を書いてチェックし、作業ログに取り込んだ指摘と取り込まなかった指摘(理由つき)を残す。コミットしてプッシュし、`git status` でブランチがきれいなことを確かめる。
9. 下の「CI を待つ」で、最後のプッシュの CI が通るまで待つ。
10. PR の URL、確かめた結果(CI を含む)、取り込んだ指摘と取り込まなかった指摘をユーザーに報告する。

## CI を待つ

CI が終わる前に報告しない。Bash の `timeout` を `600000` にして走らせる。

```bash
gh pr checks <番号> --watch --interval 30
```

- 終了コードが 0 なら通っている。
- `no checks reported` で終わったら、run がまだ登録されていない。少し置いて走らせ直す。何度か繰り返しても登録されなければ、`gh pr view <番号> --json mergeable,headRefOid` で衝突(`CONFLICTING`)やプッシュ漏れを確かめる。衝突なら `git merge origin/master` で解いて確かめ直し、プッシュして待ち直す。
- `fail` があれば、チェックの URL の run について `gh run view <run の id> --log-failed` でログを見て、ローカルで再現させて直す。作業ログに理由と直し方を足してコミット・プッシュし、待ち直す。ローカルで再現しない、または直し方が方針に関わるときはユーザーに聞く。
- 2 回走らせても終わらなければ、`gh run view <run の id> --json jobs` で止まっているジョブとステップを調べ、見立てをユーザーに伝えて止める。run の再実行や取り消しはユーザーに確かめてから行う。
