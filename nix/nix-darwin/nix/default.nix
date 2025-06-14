{
  username,
  ...
}:
{
  nix = {
    optimise.automatic = true;

    settings = {
      experimental-features = "nix-command flakes";
      substituters = [
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      trusted-users = [
        username
      ];
    };
  };
}
