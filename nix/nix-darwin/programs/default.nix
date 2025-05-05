{ pkgs, username, homedir }: {
  modules = [
    (import ./fish {
      inherit pkgs username homedir;
    })
  ];
}
