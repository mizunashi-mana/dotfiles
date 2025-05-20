{ pkgs, system }: {
  imports = [
    (import ./aerospace {
      inherit pkgs system;
    })
    (import ./vscode {
      inherit pkgs system;
    })
    (import ./1password {
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
