# add-visual-diagram-to-skills

Issue: https://github.com/mizunashi-mana/dotfiles/issues/188

## 目的・ゴール

autodev スキル（discussion / start-new-project / start-new-survey / start-new-task）で方針合意や調査結果の提示を行う際に、claude-mermaid MCP が利用可能な場合は Mermaid 図を活用して視覚的な整理を行えるようにする。

## 実装方針

- 各スキルの SKILL.md にガイドラインセクションを追加
- claude-mermaid MCP（mermaid_preview ツール）が利用可能な場合のみ図を生成する条件付き指示
- 図はあくまで補助。テキストでの説明も必ず併記する
- 各スキルの特性に合わせた図の活用場面を指示

### スキル別の変更内容

| スキル            | 追加場所                       | 図の活用場面                             |
| ----------------- | ------------------------------ | ---------------------------------------- |
| start-new-project | Step 6（計画提示時）           | タスク依存関係 + フェーズのグルーピング  |
| start-new-task    | Step 6（方針提示時）           | 変更対象のコンポーネント関係、処理フロー |
| start-new-survey  | Step 7（調査結果提示時）       | 選択肢の比較構造、技術スタックの関係図   |
| discussion        | Step 3-4（議論の整理・要約時） | 論点の構造図、関係の整理                 |

## 完了条件

- [x] 4つのスキル（discussion / start-new-project / start-new-survey / start-new-task）に Mermaid 図活用のガイドラインが追加されている
- [x] ガイドラインが MCP 利用可能時のみ適用される条件付きになっている
- [x] lint が通る

## 作業ログ

- 2026-02-27: `/autodev-discussion` で方向性を議論・合意。タスク開始
- 2026-02-27: 4つのスキルに Mermaid 図ガイドラインを追加。allowed-tools に ToolSearch を追加（MCP ツールの動的検出用）。lint パス。実装完了
