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

          environment = {
            systemPackages = [
              pkgs.fish
            ];

            shells = [
              pkgs.fish
            ];
          };

          homebrew = {
            enable = true;

            onActivation = {
              autoUpdate = true;
            };

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

          users = {
            users.${username} = {
              home = homedir;
              shell = pkgs.fish;
              ignoreShellProgramCheck = true;
            };
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

                # load global profile
                for line in (bash -c 'source /etc/bashrc && env')
                  set -l kv (string split "=" $line)
                  if contains $kv[1] PATH XDG_CONFIG_HOME XDG_DATA_DIRS XDG_CONFIG_DIRS TERMINFO_DIRS
                    set -gx $kv[1] $kv[2]
                  end
                end

                # load homebrew
                if test -d /opt/homebrew
                  eval (/opt/homebrew/bin/brew shellenv)
                else if test -d $HOME/.linuxbrew
                  eval ($HOME/.linuxbrew/bin/brew shellenv)
                else if test -d /home/linuxbrew/.linuxbrew
                  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
                end

                # add local path
                set -g fish_user_paths $HOME/.local/bin $fish_user_paths
              '';
            };

            xdg.configFile = {
              # functions
              #"fish/functions/" = {
              #  source = ./fish_functions;
              #  recursive = true;
              #};
            };

            programs.fish = {
              interactiveShellInit = ''
                # dircolor
                set -l dircolor_config $HOME/.config/dircolors/dark-256
                if test -f $dircolor_config
                  eval (dircolors -c $dircolor_config | sed 's|>&/dev/null$||')
                end
              '';
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

              # TODO: Move to home-manager configs
              pkgs.git
              pkgs.git-lfs
              pkgs.neovim
            ];
          };
        }
      ];
    };
  };
}
