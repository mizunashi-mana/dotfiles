{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.tmux = {
        enable = true;
        mouse = true;
      };
    }
  ];
}
