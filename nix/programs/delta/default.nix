{
  ...
}:
{
  homeManagerImports = [
    {
      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          navigate = true;
          dark = true;
          line-numbers = true;
          side-by-side = true;
        };
      };
    }
  ];
}
