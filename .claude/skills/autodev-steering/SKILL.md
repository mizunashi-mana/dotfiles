---
description: Update steering documents (product.md, tech.md, structure.md, etc.) to reflect current project state. Use when documents have become outdated or after completing significant work.
allowed-tools: Read, Write, Edit, MultiEdit, Bash(mkdir *), Glob, Grep, mcp__github__list_issues, mcp__github__search_issues
---

# Steering ドキュメント更新

プロジェクトの現状を確認し、steering ドキュメントを最新化します。

## 対象ドキュメント

| ファイル                        | 内容                                             |
| ------------------------------- | ------------------------------------------------ |
| `README.md`                     | プロジェクト概要、技術スタック、セットアップ手順 |
| `.ai-agent/steering/product.md` | プロダクト概要、対象環境                         |
| `.ai-agent/steering/tech.md`    | 技術スタック、開発コマンド                       |
| `.ai-agent/steering/work.md`    | 作業の進め方                                     |
| `.ai-agent/structure.md`        | ディレクトリ構成                                 |

## 手順

### 1. 現状把握

プロジェクトの実態を確認する:

- `ls nix/programs/` でプログラムモジュール一覧を確認
- `ls nix/hosts/` でホスト一覧を確認
- `cat flake.nix` で flake inputs と構成を確認
- `cat devenv.nix` で開発環境設定を確認

### 2. GitHub イシュー確認

GitHub イシューを確認し、未対応の課題や進行中のタスクを把握:

- `mcp__github__list_issues` でオープンイシューを取得
- 機能追加・バグ修正・改善などのラベルで分類

### 3. ドキュメント読み込み

各ドキュメントを読み込み、現状と比較:

- 未作成と書かれているが作成済みのもの
- 存在すると書かれているが実際にないもの
- コマンドが存在しない/変更されているもの
- ホストやプログラムの追加・削除

### 4. 陳腐化箇所の特定

ユーザーに以下の形式で報告:

```
## 陳腐化箇所

| ファイル | 箇所 | 現状 | ドキュメント記載 |
|---------|------|------|-----------------|
| tech.md | flake inputs | 追加あり | 記載なし |
| product.md | 対象環境 | 新ホスト追加 | 記載なし |
```

### 5. ユーザー確認

修正内容を提示し、承認を得る:

- 修正する項目一覧
- 修正しない項目があればその理由

### 6. 修正実行

承認後、各ファイルを編集:

- 事実に基づく修正のみ行う
- 推測で情報を追加しない

### 7. コミット

```bash
git add README.md .ai-agent/
git commit -m "Update steering documents to reflect current project state"
```

## 確認ポイント

### product.md

- 対象環境（ホスト一覧）が最新か
- 主要機能の記載が正確か

### tech.md

- flake inputs が最新か
- プログラムモジュール数が正しいか
- 開発コマンドが動作するか
- Git hooks の一覧が正しいか

### structure.md

- ディレクトリ構成が実態と一致するか
- 各ディレクトリの説明が正確か

## 注意事項

- work.md は作業フローなので、変更は慎重に
- 事実に基づく修正のみ行い、推測で情報を追加しない
