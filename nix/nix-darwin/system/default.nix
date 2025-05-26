{
  pkgs,
  username,
  homedir,
  extra-dock-persistent-apps,
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
            app = "${pkgs.vscode}/Applications/Visual Studio Code.app";
          }
          {
            app = "${pkgs.skimpdf}/Applications/Skim.app";
          }
          {
            app = "${pkgs.zotero}/Applications/Zotero.app";
          }
        ] ++ extra-dock-persistent-apps;
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
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
