# 開発ワークフロー

## 基本原則

- 方針はユーザーと合意してから着手し、合意後は方針に関わる判断が出るまで自走する
- 小さな積み重ね: 小さな単位で実装し、動作確認を繰り返す
- 文脈が切れても再開できるよう、タスクの README に方針と作業ログを残す

## タスク実行フロー

`/autodev-start-task` が次の流れを最後まで進める。

1. 仕分け: あいまいなら質問して要件を固め、調査が先なら `/autodev-start-survey`、複数 PR なら `/autodev-start-project` に回す
2. 方針の確認: 目的・方針・完了条件・ブランチ名をユーザーに確認し、`.ai-agent/tasks/` に README を書く
3. 実装: `origin/master` から切ったブランチで進め、区切りごとに `devenv shell lint-all`（pre-commit + nix flake check）で確かめる
4. PR: `/autodev-create-pr` で作る
5. レビュー: `/autodev-review-pr` で clean context の reviewer がレビューを GitHub に投稿する
6. 取り込み: Critical / Warning は直し、Info は妥当なものを直す。各スレッドに返信して解決する。Critical を直したらレビューをやり直す
7. CI を待ち、通ったら完了報告

マージは `/autodev-merge-and-switch` をユーザーが呼んだときに行う（プッシュ済み・Critical なし・スレッド解決済み・CI 通過を確かめてからマージし、master に戻ってブランチを消す）。

## レビュー形式

GitHub の PR レビュー機能（行コメント・総評）を使う。人間のレビュアーからの指摘は、専用のスキルを使わず会話の中で個別に取り込む（修正・push・スレッドへの返信と解決を依頼する）。
