{
  ...
}:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";

      # Homebrew commit e0d818b 以降、`brew bundle install --cleanup` は
      # 破壊的な cleanup の実行に --force-cleanup 等を要求するようになった。
      # nix-darwin 側の修正 (PR #1789) が未マージのため、暫定的に付与している。
      # PR がマージされ flake input を bump したら削除可能。
      # https://github.com/nix-darwin/nix-darwin/issues/1787
      extraFlags = [
        "--force-cleanup"
      ];
    };
  };
}
