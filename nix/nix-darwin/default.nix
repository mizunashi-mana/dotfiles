{
  pkgs,
  username,
  homedir,
  inputs,
  extra-dock-persistent-apps,
  extra-brews,
  extra-casks,
}:
{
  modules =
    let
      programs = import ../programs {
        inherit
          pkgs
          username
          homedir
          inputs
          ;
      };
      homeManager = import ./home-manager {
        inherit
          pkgs
          username
          homedir
          inputs
          programs
          ;
      };
    in
    [
      (import ./nix {
        inherit pkgs username homedir;
      })
      (import ./environment {
        inherit pkgs username homedir;
      })
      (import ./system {
        inherit
          pkgs
          username
          homedir
          extra-dock-persistent-apps
          ;
      })
      (import ./users {
        inherit pkgs username homedir;
      })
      (import ./homebrew {
        inherit pkgs username homedir;
        brews = extra-brews;
        casks = [
          "aquaskk"
          "chatgpt"
          "google-chrome"
          "ipe"
          "sequel-ace"
        ] ++ extra-casks;
      })
    ]
    ++ homeManager.modules
    ++ programs.nixDarwinModules;
}
