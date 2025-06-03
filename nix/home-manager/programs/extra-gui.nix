{ pkgs, system, ... }:
{
  imports = [
    (import ./vscode {
      inherit pkgs system;
    })
    (import ./skimpdf {
      inherit pkgs system;
    })
    (import ./zotero {
      inherit pkgs system;
    })
  ];
}
