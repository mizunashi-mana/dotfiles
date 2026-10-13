---
description: Start a technical survey and write the findings to .ai-agent/surveys/. Use when comparing libraries or approaches, checking feasibility, investigating a problem, or analyzing trends before deciding how to implement.
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, "Bash(mkdir *)", Skill(autodev-start-task)
---

# 調査の開始

「$ARGUMENTS」を調べ、結論を `.ai-agent/surveys/` に残す。

## 1. 問いを決める

次をユーザーに確かめる。依頼や関係する文書から読み取れるものは聞かない。

- 何を明らかにしたいか（調査の問い）
- 何を重視して選ぶか（判断基準）
- 調べないこと

## 2. 下調べ

- `.ai-agent/steering/`（`product.md`・`tech.md`・`plan.md`）と `.ai-agent/structure.md` のうち、関係するものを読む。
- `.ai-agent/surveys/` に関係する過去の調査があれば読む。

## 3. 調べる

- 公式ドキュメント、リポジトリ、Issue を一次情報として優先する。
- 必要ならローカルで小さく試す。試したものはコードと結果を書き残す。
- 秘密情報や実データは `.ai-agent/` に書かない（コミットされるため）。試すときはダミーデータを使う。
- 事実と推測を分けて記録し、出典を残す。

## 4. 書く

`.ai-agent/surveys/YYYYMMDD-<kebab-case>/README.md` に書く。長い資料は同じディレクトリに置く。

```markdown
# <調査名>

調査日: YYYY-MM-DD

## 問い

## 結論

推す案と理由。注意点。

## 比較

| 観点 | 案 A | 案 B |
| ---- | ---- | ---- |

## 詳細

## 出典
```

- 結論を先に書く。
- 調査日時点の情報であることが分かるようにする。

## 5. 報告

- 結論と推す案をユーザーに要約して伝える。
- 次の一手を提案する: `/autodev-start-task` で実装に移る、steering に反映する、追加で調べる。
