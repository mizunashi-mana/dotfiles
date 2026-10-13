# autodev スキルの自律化・簡潔化

## 目的

`.claude/skills/autodev-*` を、より自律的に（確認待ちで止まらず、PR のレビュー取り込みと CI 通過まで進める）、より短く読みやすくする。別リポジトリ（非公開）で運用している同系統のスキルの書き方を参考にする。

## 方針

- 全スキルを「何をするか」中心の短い命令文に書き直す。説明的な前置き・重複した注意事項・冗長なテンプレートを削る。
- 公開版 agent-skills の autodev-init テンプレート（mizunashi-mana/agent-skills#24）に合わせ、スキル名と構成をそろえる。
  - `autodev-start-new-*` → `autodev-start-*`、`autodev-switch-to-default` → `autodev-merge-and-switch` に改名し、`.claude/settings.json` の許可も追随する。
  - `autodev-discussion` と `autodev-import-review-suggestions` は廃止する（要件の確認と指摘の取り込みは `autodev-start-task` が行う）。
- `autodev-start-task`
  - ゴールを「レビューを取り込み、スレッドを解決し、CI が通った PR」にする。
  - 方針確認は 1 回にまとめ、以降は PR 作成 → `/autodev-review-pr` → 指摘の取り込み（スレッドへの返信・解決）→ CI 待ちまで自走する。
  - ブランチは `origin/master` から切る。
  - はっきりしない要件は、仕分けの前に AskUserQuestion で聞いて固める。
- `autodev-review-pr`: TeamCreate / SendMessage を使わず、Agent 1 回で reviewer を起動する形にする。reviewer は総評の先頭に推奨アクションと指摘の件数を書く。
- `autodev-merge-and-switch`: マージ前の安全確認（プッシュ済み・Critical なし・未解決スレッドなし・CI 通過）を入れ、マージ後にブランチを消す。ユーザーが明示的に呼んだときだけ動くようにする（`disable-model-invocation`）。
- `autodev-create-pr`: 既存 PR があれば本文更新に切り替える。
- その他（create-issue / replan / start-project / start-survey / steering）も同じ調子で簡潔にする。
- `.ai-agent/steering/work.md` の「各ステップでユーザーの確認を取る」などを新しい流れに合わせる。
- 参照元リポジトリの名前・URL・固有の内容はコミットに含めない。

## 完了条件

- [x] 全 autodev スキルが新方針で書き直されている
- [x] `work.md` / `structure.md` が新しいスキル構成と食い違わない
- [x] 参照元リポジトリの名前・URL がコミット内容に含まれない
- [x] `flake.lock` の `mizunashi-mana-skills` が #24 マージ後の revision を指す
- [x] `devenv shell lint-all` が通る
- [x] レビューを取り込んだ PR → https://github.com/mizunashi-mana/dotfiles/pull/321

## 作業ログ

- 2026-10-13: 開始
- 2026-10-13: 11 スキルと reviewer プロンプトを書き直し（1216 行 → 634 行）。`reviewer-spawn-prompt.md` を `reviewer-prompt.md` に改名。`work.md` を新しい流れに合わせて更新。`structure.md` はスキルのディレクトリ名のみの記載なので変更なし。`devenv shell lint-all` 通過
- 2026-10-13: PR #321 を作成し `/autodev-review-pr` でレビュー（Critical 0 / Warning 1 / Info 4）。すべて取り込んだ: スレッド操作を `autodev-import-review-suggestions` に一本化、switch-to-default の Critical 見送り時の条件と `no checks reported` の扱い、ブランチ作成前の `git status` 確認、create-pr で既存 PR でもプッシュ。取り込まなかった指摘なし
- 2026-10-13: mizunashi-mana/agent-skills#24 に合わせて改名・廃止（start-new-* → start-*、switch-to-default → merge-and-switch、discussion・import-review-suggestions を廃止）。テンプレートの内容を取り込み、master・`devenv shell lint-all` などは dotfiles 向けに残した。`flake.lock` の `mizunashi-mana-skills` を `9771d6d` に更新
