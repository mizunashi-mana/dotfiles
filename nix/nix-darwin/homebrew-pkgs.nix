{ pkgs, username, homedir, extraBrews, extraCasks }: {
  modules = [
    (import ./homebrew {
      inherit pkgs username homedir;
      brews = extraBrews;
      casks = [
        "aquaskk"
        "chatgpt"
        "docker"
        "google-chrome"
        "ipe"
        "sequel-ace"
        "skim"
        "vagrant"
        "zotero"
      ] ++ extraCasks;
    })
  ];
}
