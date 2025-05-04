{ pkgs, username, homedir }: {
  modules = [
    (import ./nix {
      inherit pkgs username homedir;
    })
    (import ./environment {
      inherit pkgs username homedir;
    })
    (import ./system {
      inherit pkgs username homedir;
    })
    (import ./users {
      inherit pkgs username homedir;
    })
  ];
}
