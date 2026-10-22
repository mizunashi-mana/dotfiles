---
description: Create a GitHub issue from an idea, bug report, or feature request. Use when reporting bugs, proposing new features, or documenting problems as issues.
allowed-tools: Read, AskUserQuestion, "Bash(gh issue list *)", "Bash(gh issue create *)"
---

# Issue の作成

「$ARGUMENTS」から GitHub Issue を作る。

## 1. 中身を決める

- 種類(Bug / Feature / Problem)と優先度(高 / 中 / 低)を決める。依頼から読み取れないものだけ聞く。
- `gh issue list --search "<キーワード>" --json number,title,url` で重複を確かめる。あれば伝えて止める。
- ラベル: Bug は `bug`、Feature は `enhancement`、Problem は `problem`。優先度は `priority: high` / `priority: medium` / `priority: low`。
- 本文は種類に合わせて次の見出しで書く。
  - Bug: 概要 / 再現手順 / 期待される動作 / 実際の動作 / 追加情報
  - Feature: 概要 / 背景・動機 / 提案する解決策 / 代替案
  - Problem: 課題 / 影響 / 発生状況 / アイデア(任意)

## 2. 確認して作る

タイトル・本文・ラベルをユーザーに示し、確認を取ってから作る。本文はヒアドキュメントで渡す。

```bash
gh issue create --title "<タイトル>" --label "<l1>,<l2>" --body-file - <<'BODY'
<本文>
BODY
```

作った Issue の URL をユーザーに伝える。
