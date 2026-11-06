{ packages, default-editor, ... }:
{ config, lib, ... }:
let
  tfPluginCacheDir = "${config.xdg.cacheHome}/terraform/plugin-cache";
in
{
  home = {
    stateVersion = "26.05";

    sessionPath = [
      "$HOME/.nix-profile/bin"
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = default-editor;
      # Terraform / OpenTofu のプロバイダをプロジェクトをまたいで使い回す
      TF_PLUGIN_CACHE_DIR = tfPluginCacheDir;
    };

    shellAliases = {
      editor = default-editor;
    };

    file = {
      "Workspace/MyWork/.keep".text = "";
    };

    packages = [
      packages.pkgs.cacert
    ];

    # Terraform はキャッシュのディレクトリを自分では作らないので先に作っておく
    activation.createTfPluginCacheDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p ${lib.escapeShellArg tfPluginCacheDir}
    '';
  };
}
