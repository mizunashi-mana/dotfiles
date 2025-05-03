{ extraBrews, extraCasks }: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    brews = extraBrews;

    casks = [
      "aquaskk"
      "chatgpt"
      "docker"
      "google-chrome"
      "ipe"
      "sequel-ace"
      "vagrant"
      "zotero"
    ] ++ extraCasks;
  };
}
