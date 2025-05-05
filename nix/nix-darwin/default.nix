{ pkgs, username, homedir }: {
  modules = let
    programs = import ./programs {
      inherit pkgs username homedir;
    };
  in [
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
  ] ++ programs.modules;
}
