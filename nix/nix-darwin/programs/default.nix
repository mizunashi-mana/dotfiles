{
  pkgs,
  username,
  homedir,
}:
{
  modules = [
    (import ./fish {
      inherit pkgs username homedir;
    })
    (import ./1password {
      inherit pkgs username homedir;
    })
  ];
}
