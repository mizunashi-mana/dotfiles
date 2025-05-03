{ pkgs, system }: {
  imports = [
    (import ./aerospace {
      inherit pkgs system;
    })
    (import ./vscode {
      inherit pkgs system;
    })
  ];
}
