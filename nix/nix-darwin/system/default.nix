{
  program-packages,
  username,
  homedir,
  extra-dock-persistent-apps,
  ...
}:
{
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
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };

      dock = {
        autohide = true;
        show-recents = false;
        orientation = "left";
        persistent-apps = [
          {
            app = "/System/Applications/System Settings.app";
          }
          {
            app = "/System/Applications/Utilities/Activity Monitor.app";
          }
          {
            app = "/System/Applications/App Store.app";
          }
          {
            app = "/System/Applications/Utilities/Terminal.app";
          }
          {
            app = "/Applications/Google Chrome.app";
          }
          {
            app = "/Applications/Claude.app";
          }
          {
            app = "/Applications/Antigravity IDE.app";
          }
          {
            app = "${program-packages.dbeaver}/Applications/dbeaver.app";
          }
          {
            app = "${program-packages.zotero}/Applications/Zotero.app";
          }
          {
            app = "${program-packages.raycast}/Applications/Raycast.app";
          }
        ]
        ++ extra-dock-persistent-apps;
      };

      controlcenter = {
        AirDrop = false;
        Bluetooth = false;
        BatteryShowPercentage = true;
        Sound = true;
      };

      loginwindow = {
        GuestEnabled = false;
      };

      screencapture = {
        show-thumbnail = false;
      };

      CustomUserPreferences = {
        "com.apple.inputmethod.Kotoeri" = {
          JIMPrefLiveConversionKey = 0;
        };
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
