{ pkgs, username, homedir, home-manager }: {
  modules = let
    programs = import ./programs {
      inherit pkgs username homedir;
    };
    homeManager = import ./home-manager {
      inherit pkgs username homedir home-manager;
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
  ] ++ programs.modules ++ homeManager.modules;
}
