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
    (import ./calcutils {
      inherit pkgs system;
    })
    (import ./mediautils {
      inherit pkgs system;
    })
    (import ./compressutils {
      inherit pkgs system;
    })
    (import ./gpg {
      inherit pkgs system;
    })
    (import ./git {
      inherit pkgs system;
    })
    (import ./neovim {
      inherit pkgs system;
    })
    (import ./ruby {
      inherit pkgs system;
    })
    (import ./python {
      inherit pkgs system;
    })
    (import ./rust {
      inherit pkgs system;
    })
    (import ./android-tools {
      inherit pkgs system;
    })
  ];
}
