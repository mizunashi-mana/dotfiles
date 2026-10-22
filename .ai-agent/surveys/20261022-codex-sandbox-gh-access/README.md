# Codex の sandbox で gh が動かない問題への対策

調査日: 2026-10-22（Codex 0.163.0、macOS）

## 問い

Codex の `workspace-write` sandbox の中で gh が「トークンが無効」と失敗し、Codex が承認を求め直さずに諦めてしまう。どの対策（または組み合わせ）を取るか。

判断基準は次の 3 つ。

- #322 の方針（任意の通信ができるコマンドは auto_review を通す）と合うか
- リスク（シークレットの持ち出し）
- 手間（承認の待ち時間、設定の保守）

対象は macOS だけ。Linux ホスト（bubblewrap / landlock）は調べていない。

## 結論

> **その後の判断（2026-10-22）**: ユーザーと相談し、案 B は採らなかった。ツールごとに指示が増え続けるためである。代わりに案 A（`network_access = true`）を採り、`approval_policy` を `untrusted` にして、すべてのコマンドを auto_review に通すことにした（PR #325）。`untrusted` では、rules の allow にマッチしないコマンドはすべて承認に回る（`core/src/exec_policy.rs` の `AskForApproval::UnlessTrusted`）。以下は調査した時点の推奨。

**sandbox はそのままにし、案 B（指示で `require_escalated` を求め直させる）を `programs.codex.context` で全体に入れる。案 A（`network_access = true`、PR #325）は採らない。**

- 案 A にすると gh は動く。ただし sandbox の中のどのコマンドも、review なしでキーチェーンの値を `security find-generic-password -w` で取り出せるようになる（試して確かめた）。さらに、それを任意のホストへ送れる。#322 で gh / aws の rules をやめた理由（任意のホストへ送れる）より大きな穴になる
- 発端は「gh が sandbox の中で紛らわしいエラーを出し、Codex が sandbox のせいだと気づかなかった」こと。承認を求め直せば auto_review は通している（15:43 のセッション）。なので、気づかせる指示で直接手当てできる
- 案 D（`~/.codex/rules/default.rules` に溜まった `gh api` / `gh pr` / `git push` などの allow）は、#322 の方針とすでに食い違っている。消すか残すかは別に決める。消すと待ちが増えるが、方針どおりになる
- 案 C（`network_proxy` でホストごとに許可する）は、許可外のホストを auto_review に回せるので、方針と最も合う。ただし Experimental で、ssh の git（このユーザーは `Git operations protocol: ssh`）はプロキシを通らない。さらに、許可したときもキーチェーンの窓口は開く。試していないので、すぐには採らない。待ち時間が気になったら、改めて試す

注意: 案 B は指示なので、守られないことがある。守られなかったときも、失敗して止まるだけ（安全側）。

## 比較

| 観点         | A: `network_access = true`         | B: 指示で求め直させる           | C: `network_proxy`                                          | D: `default.rules` の allow                     |
| ------------ | ---------------------------------- | ------------------------------- | ----------------------------------------------------------- | ----------------------------------------------- |
| gh が動くか  | 動く（確かめた）                   | 承認を経て動く                  | 許可したホストへは動くはず（未確認）                        | マッチするコマンドだけ、sandbox の外で動く      |
| #322 の方針  | 外れる（通信は review を通らない） | 合う                            | おおむね合う（許可外は auto_review）                        | 外れる（マッチすれば review なし）              |
| キーチェーン | sandbox の中から読める（確かめた） | 塞いだまま                      | 読める（`com.apple.SecurityServer` が足される。コードから） | sandbox の外なので読める                        |
| 持ち出し先   | 任意のホスト                       | 承認されたコマンドだけ          | 許可したホストと、承認されたホスト                          | 任意（`gh api` は任意のエンドポイントを叩ける） |
| 待ち時間     | 無い                               | gh のたびに auto_review（数秒） | 許可したホストへは無い                                      | 無い                                            |
| 保守         | 1 行                               | 指示の文面                      | Experimental。設定項目が多く、変わりうる                    | Codex が自分で書き足す。Nix の外                |

## 詳細

### 発端の再現

`codex sandbox -c sandbox_mode='"workspace-write"' -c sandbox_workspace_write.network_access=<値> -- sh -c '...'` で試した。

| 確かめたこと                                                  | `false`                                                   | `true`                      |
| ------------------------------------------------------------- | --------------------------------------------------------- | --------------------------- |
| `gh auth status`                                              | `X Failed to log in ... The token in default is invalid.` | `✓ Logged in ... (keyring)` |
| `gh api user`                                                 | `error connecting to api.github.com`                      | 成功                        |
| `curl https://api.github.com`                                 | `Could not resolve host`                                  | 200                         |
| `security find-generic-password -s gh:github.com -w` の文字数 | 0                                                         | 75（値は出力していない）    |
| `gh auth token` の文字数                                      | 0                                                         | 41                          |
| `~/.aws/credentials` を読めるか                               | 読める                                                    | 読める                      |

`false` のときの gh の失敗は、トークンが切れたように見える出力になる。そのため、sandbox に止められたと分からない。

### なぜキーチェーンも開くか

seatbelt の方針で、キーチェーンの窓口（`com.apple.SecurityServer`）への mach-lookup は、`seatbelt_network_policy.sbpl` にしか無い。これはネットワークを許可したとき（プロキシの経路を含む）にだけ足される（`sandboxing/src/seatbelt.rs`、`sandboxing/src/seatbelt_network_policy.sbpl`）。

### 何が review を通るか

`core/src/exec_policy.rs` の `render_decision_for_unmatched_command_for_platform` で決まる。`on-request` と `workspace-write` の組み合わせでは、次のとおり。

- 危険なコマンド（`rm -f` / `sudo` など）: 必ず review
- `require_escalated` で sandbox の外を求めたもの: review（`approvals_reviewer = "auto_review"` なので auto_review）
- それ以外: review なしで sandbox の中で走る。`network_access` はこの判定に関わらない
- rules の allow にマッチしたもの: review なしで sandbox の外で走る

### Codex のセッションログ

- 15:34 のセッション（logix-analytics-developer-agent）: `gh auth status` を sandbox の中で走らせて「token invalid」と出た。それを認証切れと受け取り、「gh の認証エラーにより PR 作成は未実施」と結論づけた。`require_escalated` は 0 回、`gh pr create` も 0 回
- 15:43 のセッション: 同じ `gh auth status` を `require_escalated` で求め直したところ、auto_review が承認して成功した
- logix-analytics-sub のセッション: `gh pr create` / `gh pr merge` / `gh api graphql` は、`default.rules` の allow にマッチして、承認なしに成功した。ヒアドキュメントの付いた `gh api -X POST ... <<'EOF'` は rules にマッチせず、sandbox の中で `error connecting` になった。その後、`require_escalated` で成功した

### `default.rules`

`~/.codex/rules/default.rules`（最終更新 2026-10-19 13:24）に、`gh pr` / `gh api` / `gh run` / `git push` / `git fetch` / `git pull` などの allow がある。承認のときに「今後も許可」を選ぶと、Codex が書き足す（`execpolicy/src/amend.rs`）。auto_review の承認で書き足されるかは確かめていない。

### `network_proxy`

- `features.network_proxy`（Experimental）。設定は `[permissions.<profile>.network]` に `domains = { "host" = "allow" }` を書く（`network-proxy/README.md`）
- 許可リストに無いホストは、`approval_policy` が `never` でなければ承認の流れに回る（`core/src/tools/network_approval.rs` の `allows_network_approval_flow`）
- `mode = "limited"` にすると GET / HEAD / OPTIONS だけになる。ただし HTTPS では MITM が要る
- HTTP(S) と SOCKS5 のプロキシなので、ssh の git は通らない

### 案 B の置き場所

home-manager の `programs.codex.context` が `~/.codex/AGENTS.md` を書き出す（今は無い）。文面の例:

> sandbox の中では、ネットワークと macOS のキーチェーンが塞がれている。gh / git（リモート）/ aws などが認証エラーや接続エラーを出したら、認証切れと決めつけず、同じコマンドを `sandbox_permissions: "require_escalated"` で求め直す。

## 出典

- Codex ソース（`rust-v0.163.0` タグ）: https://github.com/openai/codex
  - `codex-rs/core/src/exec_policy.rs`
  - `codex-rs/sandboxing/src/seatbelt.rs`、`seatbelt_network_policy.sbpl`
  - `codex-rs/core/src/tools/network_approval.rs`
  - `codex-rs/network-proxy/README.md`
  - `codex-rs/execpolicy/src/amend.rs`
- home-manager の `modules/programs/codex/options.nix`（`context`）
- ローカルでの試験（`codex sandbox`、上の表）
- Codex のセッションログ（`~/.codex/sessions/2026/10/22/`。中身は載せていない）
