---
description: Interactively set up autodev environment (.ai-agent/ directory, steering docs, structure.md) for a repository
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion, Bash(mkdir *)
disable-model-invocation: true
---

# autodev-init: リポジトリの autodev 開発環境初期化

## 概要

リポジトリに autodev スキルをインストールし、steering ドキュメントと structure.md を対話的に作成して、AI エージェントによる開発を始められる状態にするスキル。

## 前提条件

- プロジェクトの概要・目的をユーザーが説明できること

## メインプロセス

### Step 1: 現状把握

対象プロジェクトの現状を把握する。

1. 既存の `.ai-agent/` や `.claude/` ディレクトリの有無を確認
2. プロジェクトの基本構造を把握する（主要ディレクトリ、設定ファイル、使用言語・フレームワーク）
3. `README.md`、`package.json`、`Cargo.toml`、`pyproject.toml`、`flake.nix` など、プロジェクト情報を含むファイルを読む
4. 既存の `CLAUDE.md` があれば内容を確認する

### Step 2: プロジェクト情報のヒアリング

ユーザーに以下の情報を対話的に確認する。既存のドキュメントから読み取れる情報は確認を省略してよい。

- **プロダクトの概要**: 何を作っているか、誰のためか
- **技術スタック**: 使用言語、フレームワーク、主要ライブラリ
- **開発フェーズ**: 新規開発 / 機能追加 / 保守のいずれか
- **今後の方針**: 直近で取り組みたいこと

### Step 3: ディレクトリ構造の作成

以下のディレクトリ構造を作成する。

```
.ai-agent/
├── steering/          # 戦略的ガイドドキュメント
│   ├── product.md     # プロダクトビジョン・戦略
│   ├── tech.md        # 技術アーキテクチャ・スタック
│   ├── market.md      # 市場分析・競合調査
│   ├── plan.md        # 実装計画・ロードマップ
│   └── work.md        # 開発ワークフロー・規約
├── structure.md       # ディレクトリ構造の説明
├── projects/          # 長期プロジェクト（複数タスクにまたがる目標）
├── tasks/             # 個別タスク（日〜週単位の作業）
└── surveys/           # 技術調査・検討
```

### Step 4: steering ドキュメントの生成

各 steering ドキュメントをユーザーとの対話を通じて作成する。各ドキュメントの草案を提示し、ユーザーの確認を得てから書き込む。

#### market.md（市場分析）

プロダクトの市場環境と競合状況を記述する。情報が不足している場合はユーザーに確認する。

- **市場概要**: プロダクトが属する市場・カテゴリ
- **ターゲットセグメント**: 狙っている顧客層・ユースケース
- **競合分析**: 主要な競合プロダクトとその特徴
- **差別化ポイント**: 競合に対する優位性・独自の価値
- **市場動向**: 関連する技術トレンドや市場の変化

#### product.md（プロダクトビジョン）

以下の項目を含める。情報が不足している場合はユーザーに確認する。

- **ミッション**: プロダクトの核心的な目的
- **ターゲットユーザー**: 誰のどんな課題を解決するか
- **主要機能**: 現在提供している / 提供予定の機能一覧
- **差別化ポイント**: 競合との違い（把握している場合）

#### tech.md（技術アーキテクチャ）

リポジトリの実際の構成から以下を記述する。

- **技術スタック**: 言語、フレームワーク、主要ライブラリとバージョン
- **アーキテクチャ概要**: 全体構成、レイヤー構造、データフロー
- **パッケージ構成**: モノレポの場合、各パッケージの役割
- **開発環境**: セットアップ手順、必要なツール
- **テスト戦略**: テストフレームワーク、実行方法
- **CI/CD**: 自動化パイプラインの構成（存在する場合）

#### plan.md（実装計画）

- **現在のフェーズ**: プロダクトの開発段階
- **完了済み機能**: 既に実装されている機能のリスト
- **進行中の作業**: 現在取り組んでいるタスク
- **今後の計画**: 次に取り組む予定の機能・改善

#### work.md（開発ワークフロー）

[templates/work.md](templates/work.md) をベースに、プロジェクトの実情に合わせて調整したワークフローガイドを作成する。

### Step 5: autodev スキルのインストール

以下のスキルテンプレートをベースに、プロジェクトの `.claude/skills/` にスキルをインストールする。

#### インストール対象スキル

| スキル                              | テンプレート                                                            | 説明                          |
| ----------------------------------- | ----------------------------------------------------------------------- | ----------------------------- |
| `autodev-create-issue`              | [SKILL.md](templates/skills/autodev-create-issue/SKILL.md)              | GitHub Issue の作成           |
| `autodev-create-pr`                 | [SKILL.md](templates/skills/autodev-create-pr/SKILL.md)                 | プルリクエストの作成          |
| `autodev-discussion`                | [SKILL.md](templates/skills/autodev-discussion/SKILL.md)                | アイデアや考えの対話的な整理  |
| `autodev-import-review-suggestions` | [SKILL.md](templates/skills/autodev-import-review-suggestions/SKILL.md) | PR レビューコメントの取り込み |
| `autodev-review-pr`                 | [SKILL.md](templates/skills/autodev-review-pr/SKILL.md)                 | PR のコードレビュー           |
| `autodev-start-new-project`         | [SKILL.md](templates/skills/autodev-start-new-project/SKILL.md)         | 長期プロジェクトの開始        |
| `autodev-start-new-survey`          | [SKILL.md](templates/skills/autodev-start-new-survey/SKILL.md)          | 技術調査の開始                |
| `autodev-start-new-task`            | [SKILL.md](templates/skills/autodev-start-new-task/SKILL.md)            | 個別タスクの開始              |
| `autodev-steering`                  | [SKILL.md](templates/skills/autodev-steering/SKILL.md)                  | Steering ドキュメントの更新   |

#### インストール手順

1. 上記テーブルの各テンプレートリンクからファイルを読み込み、プロジェクトの `.claude/skills/` にコピーする
2. **プロジェクトに特化できる部分はカスタマイズする**。Step 1〜5 で把握した情報を活用して、以下のような点を調整する:
   - `autodev-start-new-task`: プロジェクト固有の動作確認手順（lint コマンド、テスト実行方法、ブラウザ確認手順など）を追記
   - `autodev-steering`: プロジェクト構成に応じた現状把握コマンド（`ls packages/`、`cat package.json | jq '.scripts'` など）を具体化
   - `autodev-review-pr`: プロジェクト固有のアーキテクチャ規約（レイヤー構造、DI パターンなど）をレビュー観点に追記
   - `autodev-create-pr`: プロジェクトの PR テンプレートパスを明記
3. ユーザーにインストールしたスキルの一覧と、行ったカスタマイズ内容を報告する

### Step 6: structure.md の生成

リポジトリの実際のファイル構造を分析し、`.ai-agent/structure.md` を生成する。

ファイルのタイトルは `# {プロジェクト名} ディレクトリ構成` とする。

**記載内容:**

- 主要ディレクトリの役割と構造（ツリー形式）
- 各ディレクトリ内の重要ファイルの説明
- アーキテクチャパターン（レイヤー構造、モジュール分割方針など）
- テスト構成（テストフレームワーク、ディレクトリ配置）

**注意事項:**

- 実際のファイルシステムを走査して正確な情報を記載する
- 本スキルで作成したファイル（`.ai-agent/` 配下や `.claude/skills/` 配下）も含める
- 推測や仮定を含めない
- 日本語で記述する

### Step 7: CLAUDE.md の確認・更新

リポジトリルートの `CLAUDE.md` を確認し、[templates/claude-md.md](templates/claude-md.md) の内容が含まれるようにする。既存の `CLAUDE.md` がある場合は内容をマージする。

### Step 8: 完了報告

セットアップ完了後、以下を報告する。

- 作成したファイルの一覧
- 各 steering ドキュメントの概要
- 利用可能なスキルの一覧
- 次のステップの提案（最初のタスクの作成など）

## 重要な注意事項

- **対話的に進める**: 各ドキュメントの草案を提示し、ユーザーの確認を得てから書き込む。一括で全て生成しない。
- **事実に基づく**: リポジトリの実際の状態に基づいて記述し、推測を含めない。
- **既存資産を尊重**: 既にあるドキュメントや設定は上書きせず、マージ・拡張する。
- **日本語で記述**: 全てのドキュメントは日本語で作成する。
