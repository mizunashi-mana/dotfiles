# add-merge-dependabot-bump-pr-skill

## 目的・ゴール

Nix グローバルスキルとして `merge-dependabot-bump-pr` スキルを追加する。dependabot が自動作成した PR をレビューし、安全と判断できればマージする。

## レビュー観点

1. **リリース経過日数**: バージョンがリリースされてから1週間以上経過しているか
2. **致命的バグ**: パッケージのリポジトリに致命的なバグ報告がないか
3. **リリースノート確認**: 注意すべき破壊的変更やセキュリティ問題が案内されていないか
4. **差分レビュー**: マルウェアのような怪しいコードが紛れていないか

## 実装方針

- `nix/programs/claude-code/skills/merge-dependabot-bump-pr/SKILL.md` を作成（Nix グローバルスキル）
- 既存スキルパターン（frontmatter + 手順）に準拠
- 単一エージェントで完結（チーム不要）
- WebSearch/WebFetch でリリース情報・バグ報告を調査
- GitHub MCP ツールで PR 操作

## 完了条件

- [x] SKILL.md が作成され、スキルとして認識される
- [x] レビュー観点4点が手順に含まれている
- [x] structure.md が更新されている
- [x] lint-all が通る

## 作業ログ

- 当初 `.claude/skills/` にプロジェクト固有スキルとして作成
- ユーザーの指示により autodev プレフィックスを外し独立スキルに変更
- さらにユーザーの指示により `nix/programs/claude-code/skills/` に移動し、Nix グローバルスキルとして配置
- structure.md のグローバルスキル一覧に追記
- lint-all 全 PASS 確認
