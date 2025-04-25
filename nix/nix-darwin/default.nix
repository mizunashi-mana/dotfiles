{ pkgs, username, homedir }: {
  system = {
    stateVersion = 5;

    defaults = {
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      NSGlobalDomain.AppleShowAllExtensions = true;

      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        _FXShowPosixPathInTitle = true;
      };

      dock = {
        autohide = true;
        show-recents = false;
        orientation = "left";
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  nix = {
    optimise.automatic = true;

    settings = {
      experimental-features = "nix-command flakes";
      download-buffer-size = 524288000; # 500MB
    };
  };

  environment = {
    systemPackages = [
      pkgs.fish
    ];

    shells = [
      pkgs.fish
    ];
  };

  users = {
    users.${username} = {
      home = homedir;
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
    };
  };
}
