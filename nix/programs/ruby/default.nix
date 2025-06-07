{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        (pkgs.ruby.withPackages (rubypkgs: [
          rubypkgs.pry
        ]))
      ];
    }
  ];
}
