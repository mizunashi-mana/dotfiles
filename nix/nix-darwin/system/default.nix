{
  packages,
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
            app = "/System/Applications/Utilities/Terminal.app";
          }
          {
            app = "/System/Applications/App Store.app";
          }
          {
            app = "/Applications/Google Chrome.app";
          }
          {
            app = "/Applications/Claude.app";
          }
          {
            app = "/Applications/Antigravity.app";
          }
          {
            app = "${packages.pkgs.vscode}/Applications/Visual Studio Code.app";
          }
          {
            app = "${packages.pkgs.skimpdf}/Applications/Skim.app";
          }
          {
            app = "${packages.pkgs.zotero}/Applications/Zotero.app";
          }
          {
            app = "${packages.pkgs.dbeaver-bin}/Applications/dbeaver.app";
          }
          {
            app = "${packages.pkgs.raycast}/Applications/Raycast.app";
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
