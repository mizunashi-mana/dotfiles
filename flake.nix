{
  description = "A fake to setup user environment";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
  }: let
    username = "workuser";
    homedir = "/Users/${username}";
    hostname = "MacBook-Air-2nd";
    system = "aarch64-darwin";

    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;

      modules = [
        {
          system = {
            stateVersion = 5;

            defaults = {
              SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
              NSGlobalDomain.AppleShowAllExtensions = true;

              finder = {
                AppleShowAllFiles = true;
                AppleShowAllExtensions = true;
                ShowPathbar = true;
                _FXShowPosixPathInTitle = true;
              };

              dock = {
                autohide = true;
                show-recents = false;
                orientation = "left";
              };
            };
          };

          nix = {
            optimise.automatic = true;

            settings = {
              experimental-features = "nix-command flakes";
              download-buffer-size = 524288000; # 500MB
            };
          };

          users = {
            users.${username}.home = homedir;
          };

          environment = {
            systemPackages = [
              pkgs.fish
            ];
          };

          homebrew = {
            enable = true;

            onActivation = {
              autoUpdate = true;
            };

            brews = [
              "neovim"
              "git"
              "git-lfs"
            ];

            casks = [
              "aerospace"
              "docker"
              "google-chrome"
              "ipe"
              "session-manager-plugin"
              "vagrant"
              "zotero"
            ];
          };
        }
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = {
            home.stateVersion = "24.11";

            home.username = username;
            home.homeDirectory = homedir;

            programs.home-manager = {
              enable = true;
            };

            programs.fish = {
              enable = true;

              shellInit = ''
                # suppress fish_greeting
                set fish_greeting

                # theme
                set fish_theme yimmy

                # load nix profile
                if test -d /etc/profiles/per-user/(whoami)/bin
                  fish_add_path /etc/profiles/per-user/(whoami)/bin
                end

                # dircolor
                set -l dircolor_config $HOME/.config/dircolors/dark-256
                if test -f $dircolor_config
                  eval (dircolors -c $dircolor_config | sed 's|>&/dev/null$||')
                end
              '';
            };

            xdg.configFile = {
              # functions
              #"fish/functions/" = {
              #  source = ./fish_functions;
              #  recursive = true;
              #};
            };

            programs.awscli = {
              enable = true;
            };

            programs.direnv = {
              enable = true;
            };

            programs.gh = {
              enable = true;
              settings = {
                git_protocol = "ssh";
                prompt = "enabled";
              };
            };

            programs.gpg = {
              enable = true;
            };

            programs.jq = {
              enable = true;
            };

            programs.man = {
              enable = true;
            };

            programs.poetry = {
              enable = true;
              settings = {
                virtualenvs.create = true;
                virtualenvs.in-project = true;
              };
            };

            programs.texlive = {
              enable = true;
            };

            programs.tmux = {
              enable = true;
              mouse = true;
            };

            programs.zoxide = {
              enable = true;
            };

            home.packages = [
              pkgs.arp-scan
              pkgs.cacert
              pkgs.coreutils
              pkgs.curl
              pkgs.exiftool
              pkgs.ffmpeg
              pkgs.gcc
              pkgs.getopt
              pkgs.gettext
              pkgs.ghostscript
              pkgs.gnumake
              pkgs.gnum4
              pkgs.gnuplot
              pkgs.gnused
              pkgs.graphviz
              pkgs.imagemagick
              pkgs.inetutils
              pkgs.nkf
              pkgs.nmap
              pkgs.poppler
              pkgs.wget
              pkgs.w3m
              pkgs.z3
            ];
          };
        }
      ];
    };
  };
}
