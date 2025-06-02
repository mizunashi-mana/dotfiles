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
      programs = import ./programs {
        inherit pkgs username homedir;
      };
      homeManager = import ./home-manager {
        inherit
          pkgs
          username
          homedir
          inputs
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
          "1password"
          "aquaskk"
          "chatgpt"
          "google-chrome"
          "ipe"
          "sequel-ace"
          "vagrant"
        ] ++ extra-casks;
      })
    ]
    ++ programs.modules
    ++ homeManager.modules;
}
