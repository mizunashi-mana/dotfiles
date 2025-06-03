{
  pkgs,
  system,
  username,
  homedir,
  inputs,
  extra-dock-persistent-apps,
  extra-brews ? [ ],
  extra-casks ? [ ],
  extra-programs ? [ ],
}:
{
  modules =
    let
      programs = import ../programs {
        inherit
          pkgs
          system
          username
          homedir
          inputs
          ;
      };
      extra-programs-hm-imports = programs.mkHomeManagerImports {
        programs = extra-programs;
      };
      extra-programs-nix-darwin-modules = programs.mkNixDarwinModules {
        programs = extra-programs;
      };
      home-manager = import ./home-manager {
        inherit
          pkgs
          username
          homedir
          inputs
          ;
        extra-imports = programs.homeManagerImports ++ extra-programs-hm-imports;
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
        casks = extra-casks;
      })
    ]
    ++ home-manager.modules
    ++ programs.nixDarwinModules
    ++ extra-programs-nix-darwin-modules;
}
