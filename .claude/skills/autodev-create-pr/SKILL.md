---
description: Create a GitHub pull request following this project's conventions (PR template path, body language, branch policy). ALWAYS invoke this skill before running `gh pr create` — do NOT bypass it with the generic PR creation flow built into Claude Code. Use whenever changes on a feature branch are ready for review and you want to open a PR.
allowed-tools: Read, Glob, "Bash(git status *)", "Bash(git log *)", "Bash(git diff *)", "Bash(git push *)", "Bash(git branch --show-current)", "Bash(gh pr view *)", "Bash(gh pr create *)", "Bash(gh pr edit *)"
---

# PR 作成

現在のブランチの変更内容から PR を作成します。

## 手順

1. **現在の状態を確認**:
   - `git status` で未コミットの変更がないか確認
   - `git log master..HEAD --oneline` で master からのコミット一覧を確認
   - `git diff master...HEAD --stat` で変更ファイルを確認

2. **リモートにプッシュ**:
   - ブランチがリモートにない場合は `git push -u origin <branch>` でプッシュ

3. **PR テンプレートを確認**:
   - `.github/PULL_REQUEST_TEMPLATE.md` があれば読み込む

4. **PR を作成**:
   - `gh pr create --title "<タイトル>" --body-file -` を使用（本文はヒアドキュメントで標準入力から渡す）:
     <!-- pr-language: ja -->

     ```bash
     gh pr create --title "<タイトル>" --body-file - <<'BODY'
     ## 目的
     変更の背景・目的

     ## 変更概要
     - 主な変更点を箇条書き
     BODY
     ```

     <!-- /pr-language -->

   - タイトル: 変更内容を簡潔に要約
   - ボディ: PR テンプレートに沿って記載
   - 注意点：`--body-file -` でヒアドキュメントから渡せば改行が `\n` にエスケープされない

5. **PR の内容を確認**:
   - `gh pr view <number> --json body` で作成された PR の本文を取得
   - 改行が `\n` のようにエスケープされたまま表示されていないか確認
   - 問題がある場合は `gh pr edit <number> --body-file -` で修正する

6. **PR URL を報告**:
   - 作成した PR の URL をユーザーに伝える

## 注意事項

- コミットが済んでいない変更がある場合は、先にコミットするか確認する
- master ブランチへの直接プッシュは避ける
- <!-- pr-language: ja -->PR タイトルは日本語で簡潔に（50文字以内推奨）<!-- /pr-language -->
