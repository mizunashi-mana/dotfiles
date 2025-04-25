{ extraCasks }: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

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
