{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        (packages.pkgs.ruby.withPackages (rubypkgs: [
          rubypkgs.pry
        ]))
      ];
    }
  ];
}
