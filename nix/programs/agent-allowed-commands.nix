# Claude Code と Codex の双方で確認なしに走らせるコマンド（前方一致の単語の並び）。
# 次を満たすものだけを入れる。満たさないが Claude では許すものは claude-code/default.nix に書く。
# - 消したり上書きしたりしない
# - 外へ公開しない（push・PR やコメントの作成・マージなどをしない）
# - 書き込みは手元のメタデータとキャッシュ（refs/remotes など）だけ
# - 止めない限り終わらないもの（tail -f など）ではない
# git fetch などは相手を origin に固定する。相手がローカルパスだと --upload-pack（省略形や = つきも効く）で
# 手元の任意のコマンドが 1 回で走るため。origin を手元のパスに向けるには回りくどい手順が要る。
# Codex では allow に当たると review なしで sandbox の外で走る。引数で送り先を変えられること
# （gh -R・URL・git fetch <URL>）、入れ子のリポジトリの .git/config で git から任意の実行ができること、
# git diff / log / show の --output で任意の場所に書けることは、そこに至る回りくどい手順の途中で auto_review が止める見込みで受け入れている。
# 名前で許可するので、PATH や絶対パスで作業ディレクトリに置いた偽物を呼ばれうるが、
# 人が実行するときも気付けない穴なので受け入れる。
# 判断の経緯: .ai-agent/tasks/20261022-shared-agent-allowlist/README.md
[
  [ "basename" ]
  [ "cat" ]
  [ "comm" ]
  [ "date" ]
  [ "diff" ]
  [ "echo" ]
  [
    "gh"
    "cache"
    "list"
  ]
  [
    "gh"
    "issue"
    "list"
  ]
  [
    "gh"
    "issue"
    "view"
  ]
  [
    "gh"
    "label"
    "list"
  ]
  [
    "gh"
    "pr"
    "checks"
  ]
  [
    "gh"
    "pr"
    "diff"
  ]
  [
    "gh"
    "pr"
    "list"
  ]
  [
    "gh"
    "pr"
    "view"
  ]
  [
    "gh"
    "release"
    "list"
  ]
  [
    "gh"
    "release"
    "view"
  ]
  [
    "gh"
    "repo"
    "view"
  ]
  [
    "gh"
    "run"
    "list"
  ]
  [
    "gh"
    "run"
    "view"
  ]
  [
    "gh"
    "run"
    "watch"
  ]
  [
    "gh"
    "search"
  ]
  [
    "git"
    "--version"
  ]
  [
    "git"
    "check-ignore"
  ]
  [
    "git"
    "diff"
  ]
  [
    "git"
    "fetch"
    "origin"
  ]
  [
    "git"
    "log"
  ]
  [
    "git"
    "ls-files"
  ]
  [
    "git"
    "ls-remote"
    "origin"
  ]
  [
    "git"
    "ls-tree"
  ]
  [
    "git"
    "merge-base"
  ]
  [
    "git"
    "remote"
    "get-url"
  ]
  [
    "git"
    "remote"
    "prune"
    "origin"
  ]
  [
    "git"
    "rev-parse"
  ]
  [
    "git"
    "show"
  ]
  [
    "git"
    "status"
  ]
  [
    "git"
    "submodule"
    "status"
  ]
  [ "grep" ]
  [ "head" ]
  [ "jq" ]
  [ "ls" ]
  [ "lsof" ]
  [ "od" ]
  [ "otool" ]
  [ "pgrep" ]
  [ "printf" ]
  [ "ps" ]
  [ "pwd" ]
  [ "readlink" ]
  [ "sleep" ]
  [ "strings" ]
  [ "tail" ]
  [ "test" ]
  [ "true" ]
  [ "wc" ]
  [ "which" ]
]
