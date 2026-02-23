# agent-skills-nix による 3rd party skills インストール対応

## 目的・ゴール

`github:Kyure-A/agent-skills-nix` の Home Manager モジュールを導入し、`nix/programs/` の仕組みを使って宣言的に 3rd party agent skills をインストールできるようにする。

## 実装方針

### 概要

`nix/programs/default.nix` に `mkProgramsAgentSkills` ヘルパー関数を追加する。この関数は `agentSkills` 設定リストを受け取り、`programs.agent-skills` の Home Manager モジュール設定を生成する。

### 詳細

1. **`nix/programs/default.nix` に `mkProgramsAgentSkills` を追加**
   - `agentSkills` 設定（sources, skills, targets）を受け取り、`programs.agent-skills` の Home Manager import を生成
   - 既存の `mkHomeManagerImports` などと同じパターンで利用可能にする

2. **`nix/programs/agent-skills-anthropic/default.nix` を `mkProgramsAgentSkills` を使うように書き換え**
   - 現在ハードコードされている設定を `mkProgramsAgentSkills` 経由で生成するように変更

3. **`default-common.nix` に agent-skills-anthropic を追加**
   - 全環境で anthropic skills を利用可能にする

4. **Home Manager モジュールの import を追加**
   - `agent-skills.homeManagerModules.default` を Home Manager の imports に追加
   - nix-darwin と standalone Home Manager の両方で対応

## 完了条件

- [x] `mkProgramsAgentSkills` が `nix/programs/default.nix` に存在する
- [x] `agent-skills-anthropic` が `default-common.nix` に含まれている
- [x] `agent-skills.homeManagerModules.default` が Home Manager に import されている
- [x] `devenv shell lint-all` が通る

## 作業ログ

- `nix/programs/default.nix` に `mkProgramsAgentSkills` を追加
- `nix/programs/default-common.nix` と `default-darwin.nix` で `mkProgramsAgentSkills` を使用
- `nix/nix-darwin/default.nix` の `extra-programs` にも `mkProgramsAgentSkills` を適用
- `nix/home-manager/default.nix` に `inputs.agent-skills.homeManagerModules.default` を追加
- `flake.lock` が agent-skills / anthropic-skills inputs で更新された
- `devenv shell lint-all` 通過（nixfmt 自動修正後）
