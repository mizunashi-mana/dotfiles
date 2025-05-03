{ pkgs }: {
  imports = [
    (import ./aerospace {
      inherit pkgs;
    })
    (import ./vscode {
      inherit pkgs;
    })
  ];
}
