# autodev スキルの自律化・簡潔化

## 目的

`.claude/skills/autodev-*` を、より自律的に（確認待ちで止まらず、PR のレビュー取り込みと CI 通過まで進める）、より短く読みやすくする。別リポジトリ（非公開）で運用している同系統のスキルの書き方を参考にする。

## 方針

- 全スキルを「何をするか」中心の短い命令文に書き直す。説明的な前置き・重複した注意事項・冗長なテンプレートを削る。
- スキル名（`autodev-*`）は変えない（`.claude/settings.json` の許可や手癖を壊さないため）。
- `autodev-start-new-task`
  - ゴールを「レビューを取り込み、スレッドを解決し、CI が通った PR」にする。
  - 方針確認は 1 回にまとめ、以降は PR 作成 → `/autodev-review-pr` → 指摘の取り込み（スレッドへの返信・解決）→ CI 待ちまで自走する。
  - ブランチは `origin/master` から切る。
  - 仕分け先に `/autodev-discussion` を残す。
- `autodev-review-pr`: TeamCreate / SendMessage を使わず、Agent 1 回で reviewer を起動する形にする。`reviewer-spawn-prompt.md` は `reviewer-prompt.md` に改名し、結果を返り値で返す形にする。
- `autodev-import-review-suggestions`: 人間のレビューにも使えるよう残しつつ、GraphQL の返信・解決を使う短い手順にする。
- `autodev-switch-to-default`: マージ前の安全確認（プッシュ済み・Critical なし・未解決スレッドなし・CI 通過）を入れ、ユーザーが明示的に呼んだときだけ動くようにする（`disable-model-invocation`）。
- `autodev-create-pr`: 既存 PR があれば本文更新に切り替える。
- その他（create-issue / discussion / replan / start-new-project / start-new-survey / steering）も同じ調子で簡潔にする。
- `.ai-agent/steering/work.md` の「各ステップでユーザーの確認を取る」などを新しい流れに合わせる。
- 参照元リポジトリの名前・URL・固有の内容はコミットに含めない。

## 完了条件

- [x] 全 autodev スキルが新方針で書き直されている
- [x] `work.md` / `structure.md` が新しいスキル構成と食い違わない
- [x] 参照元リポジトリの名前・URL がコミット内容に含まれない
- [x] `devenv shell lint-all` が通る
- [ ] レビューを取り込んだ PR → <URL>

## 作業ログ

- 2026-10-13: 開始
- 2026-10-13: 11 スキルと reviewer プロンプトを書き直し（1216 行 → 634 行）。`reviewer-spawn-prompt.md` を `reviewer-prompt.md` に改名。`work.md` を新しい流れに合わせて更新。`structure.md` はスキルのディレクトリ名のみの記載なので変更なし。`devenv shell lint-all` 通過
