{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };
    }
  ];
}
