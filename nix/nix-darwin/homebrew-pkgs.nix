{ extraBrews, extraCasks }: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    brews = extraBrews;

    casks = [
      "chatgpt"
      "docker"
      "google-chrome"
      "ipe"
      "session-manager-plugin"
      "vagrant"
      "zotero"
    ] ++ extraCasks;
  };
}
