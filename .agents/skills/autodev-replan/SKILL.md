---
description: Replan the roadmap in .ai-agent/steering/plan.md by reviewing completed work, open issues, and market trends. Use when the roadmap has become outdated or after completing significant milestones.
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, "Bash(ls *)", "Bash(mkdir *)", "Bash(git log *)", "Bash(gh issue list *)", "Bash(git status *)", "Bash(git fetch *)", "Bash(git switch *)", "Bash(git add *)", "Bash(git commit *)", Skill(autodev-create-pr), Skill(autodev-steering)
---

# ロードマップの見直し

`.ai-agent/steering/plan.md`(ロードマップ)と `.ai-agent/steering/market.md`(市場・関連ツールの動向)を、ユーザーとの対話で見直す。事実関係の更新だけなら `/autodev-steering` を使う。どちらかのファイルが無ければ、作るかをユーザーに聞く。

## 1. 現状をつかむ

- 実装: `ls nix/programs/`、`ls nix/hosts/`、`ls .agents/skills/`、`flake.nix`、`.ai-agent/tasks/` と `.ai-agent/projects/`、`git log --oneline -30`
- plan.md の各項目を実装と照らし、完了・進行中・未着手・一部完了に分ける。
- `gh issue list --state open --json number,title,labels,url` で、ロードマップに無い課題を拾う。
- market.md を読み、WebSearch / WebFetch で関連ツール・技術の最新の動向を調べ、古くなった箇所を挙げる。

## 2. 報告する

完了・進行中・未着手・新たな課題(Issue など)・動向の変化を表にまとめてユーザーに示す。

## 3. 対話で決める

一方的に計画を出さず、方向性と優先順位をユーザーに確かめながら決める。

- 完了した項目を plan.md から消すか
- 既存の項目の優先順位
- 足す項目・マイルストーン、フェーズの組み直し

推測で計画を足さない。

## 4. 反映する

- plan.md と market.md の変更内容を示し、承認を得てから書き換える。
- `master` に居るなら `git fetch origin` の後 `git switch --no-track -c replan-roadmap origin/master` でブランチを作り、コミットして `/autodev-create-pr` で PR を作る。
- product.md・tech.md など他の steering 文書の更新が要るなら `/autodev-steering` を案内する。
