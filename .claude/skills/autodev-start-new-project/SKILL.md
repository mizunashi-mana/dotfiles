---
description: Break a large goal into PR-sized tasks with dependencies and record it in .ai-agent/projects/. Use when a feature, refactoring, or multi-week initiative spans multiple PRs.
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, "Bash(mkdir *)", Skill(autodev-start-new-task), Skill(autodev-start-new-survey)
---

# プロジェクトの開始

「$ARGUMENTS」を 1 PR ずつのタスクに分け、`.ai-agent/projects/` に置く。

## 1. 下調べ

- `.ai-agent/steering/` と `.ai-agent/structure.md` のうち、関係するものを読む。
- 既存のコードで前提を確かめる。

## 2. 分ける

- 各タスクは `/autodev-start-new-task` で 1 PR に収まる大きさにする。
- 先に調べないと分けられない部分は、調査タスク(`/autodev-start-new-survey`)として置く。
- 依存を書き、循環が無いこと、依存なしで着手できるタスクがあることを確かめる。

## 3. 書く

`.ai-agent/projects/YYYYMMDD-<kebab-case>/README.md` に書く。

```markdown
# <プロジェクト名>

## 目標

完了条件を含める。

## やらないこと

## タスク

| ID  | タスク | 依存 | 状態   | PR  |
| --- | ------ | ---- | ------ | --- |
| T1  | ...    | -    | 未着手 |     |
| T2  | ...    | T1   | 未着手 |     |

### T1: <タスク名>

- 内容:
- 完了条件:

## 経過

- YYYY-MM-DD: 開始
```

## 4. 確認

目標、やらないこと、分け方、依存、最初に着手するタスクをユーザーに示し、同意を得る。同意を得たら最初のタスクを `/autodev-start-new-task` で始めてよいかも合わせて聞く。

## 5. 進め方

- タスクは `/autodev-start-new-task T1 <タスク名>` のように ID を添えて始める。タスクの README からこの README へリンクする。
- タスクを始めたら状態を「進行中」に、PR を作ったら PR の URL を、マージされたら「完了」にし、経過に 1 行足す。
- 全タスクが終わったら目標を満たしたかを確かめ、経過に完了を書いてユーザーに報告する。
