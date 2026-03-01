---
description: Review and merge a Dependabot bump PR after safety checks. Use when Dependabot has created version bump PRs and you want to review and merge them.
allowed-tools: Read, Glob, Grep, "Bash(git remote get-url *)", WebSearch, WebFetch, AskUserQuestion, mcp__github__list_pull_requests, mcp__github__pull_request_read, mcp__github__merge_pull_request, mcp__github__get_latest_release, mcp__github__get_release_by_tag, mcp__github__search_issues, mcp__github__get_file_contents, mcp__github__list_commits
---

# Dependabot Bump PR のレビュー＆マージ

dependabot が自動作成したバージョンバンプ PR をレビューし、安全と判断できればマージします。

## 手順

### 1. リポジトリ情報の取得

- `git remote get-url origin` から owner/repo を特定

### 2. 対象 PR の特定

- `$ARGUMENTS` が指定されている場合: その PR 番号を使用
- `$ARGUMENTS` が空の場合:
  1. `mcp__github__list_pull_requests` で オープン PR を一覧取得
  2. 結果から author が `dependabot[bot]` の PR をフィルタ
  3. dependabot PR が複数ある場合は AskUserQuestion で対象を選択
  4. dependabot PR が1つもない場合は「対象 PR がありません」と報告して終了

### 3. PR 情報の取得

- `mcp__github__pull_request_read` で PR の基本情報を取得（method: `get`）
- タイトル・説明からパッケージ名とバージョン（旧 → 新）を特定
  - dependabot の PR タイトルは通常 "Bump {package} from {old} to {new}" 形式
- `mcp__github__pull_request_read` で差分を取得（method: `get_diff`）

### 4. パッケージ情報の特定

PR 情報から以下を抽出:

- **パッケージのリポジトリ**: owner/repo 形式
  - GitHub Actions の場合: `uses: owner/repo@tag` から特定
  - npm / pip 等の場合: パッケージ名から GitHub リポジトリを WebSearch で特定
- **新バージョン**: バンプ先のバージョン番号またはタグ

### 5. レビュー: リリース経過日数の確認

新バージョンがリリースされてから **1週間以上** 経過しているか確認する。

- `mcp__github__get_release_by_tag` または `mcp__github__get_latest_release` でリリース情報を取得
  - GitHub Actions の場合: タグ名は `v{version}` 形式が多い
- リリース日（`published_at`）から現在までの経過日数を計算
- **判定**:
  - 7日以上経過: PASS
  - 7日未満: WARN（「リリースから {N}日 しか経過していません」）
  - リリース情報が取得できない: WARN（「リリース日を確認できませんでした」）

### 6. レビュー: 致命的バグ報告の確認

新バージョンに対する致命的なバグ報告がないか確認する。

- `mcp__github__search_issues` でパッケージリポジトリの Issue を検索
  - キーワード: 新バージョン番号 + `bug` / `regression` / `breaking`
  - `state: "open"` で検索
- 致命的と思われる Issue がある場合は内容を確認
- **判定**:
  - 致命的バグ報告なし: PASS
  - 致命的バグ報告あり: FAIL（Issue のタイトルと URL を報告）
  - 判断が難しい場合: WARN（Issue 情報を添えて報告）

### 7. レビュー: リリースノートの確認

リリースノートに注意すべき変更がないか確認する。

- 手順5で取得したリリース情報の `body`（リリースノート）を確認
- 以下の点を重点的にチェック:
  - **Breaking changes**: 破壊的変更の有無
  - **Deprecation**: 非推奨化の案内
  - **Security advisories**: セキュリティ修正（あれば早めのマージを推奨）
  - **Migration required**: マイグレーションが必要な変更
- **判定**:
  - 注意すべき変更なし: PASS
  - Breaking changes / Migration required あり: FAIL（詳細を報告）
  - Deprecation のみ: WARN（内容を報告）
  - Security fix: PASS（早期マージ推奨として報告）

### 8. レビュー: パッケージの差分の安全性確認

パッケージの旧バージョンから新バージョンへのソースコード差分に、マルウェアや不審なコードが含まれていないか確認する。

- パッケージリポジトリの旧バージョンと新バージョンの比較ページを WebFetch で取得
  - `https://github.com/{owner}/{repo}/compare/{old_tag}...{new_tag}` を使用
- 差分が大きい場合は `mcp__github__list_commits` で新旧タグ間のコミット一覧を取得し、各コミットの概要を確認
- 以下の観点で精査:
  - 難読化されたコード（Base64 エンコード、eval、動的コード生成）が追加されていないか
  - 外部への通信（未知のドメインへの HTTP リクエスト、データ送信）が追加されていないか
  - 環境変数やシークレットの読み取り・送信が追加されていないか
  - ファイルシステムへの想定外のアクセス（ホームディレクトリ、SSH 鍵、認証情報の読み取り等）がないか
  - パッケージの目的に不釣り合いな権限の要求や機能の追加がないか
- **判定**:
  - 不審なコードなし: PASS
  - 不審なコードあり: FAIL（該当コードと懸念点を報告）
  - 差分が大きすぎて全量確認が困難: WARN（確認できた範囲と未確認の範囲を報告）

### 9. レビュー結果の報告

4観点の結果をまとめてユーザーに報告する。

```
## レビュー結果: {PR タイトル}

| 観点               | 判定 | 詳細                        |
| ------------------ | ---- | --------------------------- |
| リリース経過日数   | PASS | リリースから {N}日 経過      |
| 致命的バグ報告     | PASS | 報告なし                    |
| リリースノート     | PASS | 注意すべき変更なし          |
| 差分の安全性       | PASS | バージョン番号の変更のみ    |

**総合判定**: PASS — マージ可能です
```

### 10. マージ判定とユーザー確認

総合判定に基づいて分岐:

- **全て PASS の場合**:
  - AskUserQuestion でマージの最終確認（「マージしてよいですか？」）
  - ユーザーが承認したらマージ

- **WARN を含む場合**:
  - WARN の内容を強調して提示
  - AskUserQuestion でユーザーの判断を仰ぐ（「WARN がありますがマージしますか？」）
  - ユーザーが承認したらマージ

- **FAIL を含む場合**:
  - 「以下の理由でマージを推奨しません」と報告
  - マージせずにスキル終了
  - ユーザーが明示的にマージを指示した場合のみマージ可

### 11. マージ実行

- `mcp__github__merge_pull_request` でマージ
  - `merge_method: "merge"`（マージコミット方式）
- マージ完了後、PR URL と結果を報告

## 注意事項

- dependabot 以外の PR が指定された場合は、その旨を警告してからレビューを続行するか確認
- パッケージリポジトリの情報取得に失敗した場合は WARN として扱い、ユーザーに判断を委ねる
- リリースノートが長大な場合は重要な変更点のみ抜粋して報告
