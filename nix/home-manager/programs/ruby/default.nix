{ pkgs, ... }: {
  home.packages = [
    (pkgs.ruby.withPackages (rubypkgs: [
      rubypkgs.pry
    ]))
  ];
}
