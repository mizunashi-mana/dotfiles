{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.poetry = {
        enable = true;
        settings = {
          virtualenvs.create = true;
          virtualenvs.in-project = true;
        };
      };
    }
  ];
}
