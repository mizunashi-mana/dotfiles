---
description: Update steering documents (README.md, product.md, tech.md, work.md, structure.md) to match the current state of the repository. Use when documents have become outdated or after completing significant work.
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion, "Bash(ls *)", "Bash(gh issue list *)", "Bash(git status *)", "Bash(git fetch *)", "Bash(git switch *)", "Bash(git add *)", "Bash(git commit *)", Skill(autodev-create-pr)
---

# steering 文書の更新

steering 文書を、リポジトリの実態に合わせる。事実に基づく修正だけを行い、推測で足さない。

| ファイル                        | 内容                                             |
| ------------------------------- | ------------------------------------------------ |
| `README.md`                     | プロジェクト概要、技術スタック、セットアップ手順 |
| `.ai-agent/steering/product.md` | プロダクト概要、対象環境(ホスト一覧)             |
| `.ai-agent/steering/tech.md`    | 技術スタック、flake inputs、開発コマンド、hooks  |
| `.ai-agent/steering/work.md`    | 作業の進め方(変えるときは慎重に)                 |
| `.ai-agent/structure.md`        | ディレクトリ構成                                 |

## 1. 実態を集める

- `ls nix/programs/`、`ls nix/hosts/`、`ls .claude/skills/`
- `flake.nix` の inputs と構成、`devenv.nix` の設定
- `gh issue list --state open --json number,title,labels,url`

## 2. ずれを洗い出す

文書を読み、実態と比べる(無いと書いてあるが有るもの、有ると書いてあるが無いもの、変わったコマンド、ホスト・モジュールの増減など)。次の形でユーザーに示し、直す範囲の確認を取る。

```
| ファイル | 箇所 | 実態 | 文書の記載 |
| -------- | ---- | ---- | ---------- |
```

## 3. 直す

- 確認の取れた箇所を直す。
- `master` に居るなら `git fetch origin` の後 `git switch --no-track -c update-steering-docs origin/master` でブランチを作り、コミットして `/autodev-create-pr` で PR を作る。
