{ pkgs, username, homedir }: {
  system = {
    stateVersion = 6;

    primaryUser = username;

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

      controlcenter = {
        AirDrop = false;
        Bluetooth = false;
        BatteryShowPercentage = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
