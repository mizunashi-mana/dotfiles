{ pkgs }: {
  imports = [
    (import ./editorconfig {
      inherit pkgs;
    })
  ];
}
