{ ... }:
{
  nix = {
    extraOptions = builtins.readFile ./nix.conf;
  };
}
