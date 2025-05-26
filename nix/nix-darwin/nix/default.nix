{
  pkgs,
  username,
  homedir,
}:
{
  nix = {
    optimise.automatic = true;

    settings = {
      experimental-features = "nix-command flakes";
      download-buffer-size = 524288000; # 500MB
    };
  };
}
