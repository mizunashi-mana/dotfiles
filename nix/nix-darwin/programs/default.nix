{
  pkgs,
  username,
  homedir,
}:
{
  modules = [
    (import ./1password {
      inherit pkgs username homedir;
    })
  ];
}
