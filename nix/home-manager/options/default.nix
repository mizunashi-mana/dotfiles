{ pkgs, ... }:
{
  imports = [
    (import ./editorconfig {
      inherit pkgs;
    })
    (import ./home {
      inherit pkgs;
    })
  ];
}
