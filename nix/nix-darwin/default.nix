{
  packages,
  system,
  username,
  homedir,
  inputs,
  extra-dock-persistent-apps,
  extra-programs ? [ ],
}:
{
  modules =
    let
      programs = import ../programs {
        inherit
          packages
          system
          username
          homedir
          inputs
          ;
      };
      programs-darwin = import ../programs/default-darwin.nix {
        inherit
          packages
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
          packages
          username
          homedir
          inputs
          ;
        extra-imports = programs.homeManagerImports ++ extra-programs-hm-imports;
      };
    in
    [
      (import ./nix {
        inherit packages username homedir;
      })
      (import ./system {
        inherit
          packages
          username
          homedir
          extra-dock-persistent-apps
          ;
      })
      (import ./users {
        inherit packages username homedir;
      })
      (import ./homebrew {
        inherit packages username homedir;
      })
    ]
    ++ home-manager.modules
    ++ programs.nixDarwinModules
    ++ programs-darwin.nixDarwinModules
    ++ extra-programs-nix-darwin-modules;
}
