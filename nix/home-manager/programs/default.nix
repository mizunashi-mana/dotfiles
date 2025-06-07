{
  pkgs,
  system,
  inputs,
  ...
}:
{
  imports = [
    ({
      programs.home-manager = {
        enable = true;
      };
    })
    (import ./coreutils {
      inherit pkgs system;
    })
    (import ./netutils {
      inherit pkgs system;
    })
  ];
}
