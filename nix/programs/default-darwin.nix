{
  packages,
  system,
  inputs,
  ...
}:
let
  default = import ./default.nix { inherit system inputs packages; };

  dbeaver = import ./dbeaver { inherit packages; };
  zotero = import ./zotero { inherit packages; };
  raycast = import ./raycast { inherit packages; };

  programs = [
    (import ./default-common.nix { inherit system inputs packages; })
    (import ./mas { inherit packages; })
    (import ./z3 { inherit packages; })
    (import ./gcc { inherit packages; })
    (import ./lnav { inherit packages; })
    (import ./m4 { inherit packages; })
    (import ./arp-scan { inherit packages; })
    (import ./tmux { inherit packages; })
    (import ./awscli { inherit packages; })
    (import ./lha { inherit packages; })
    (import ./gnuplot { inherit packages; })
    (import ./graphviz { inherit packages; })
    (import ./ffmpeg { inherit packages; })
    (import ./exiftool { inherit packages; })
    (import ./imagemagick { inherit packages; })
    (import ./ghostscript { inherit packages; })
    (import ./ruby { inherit packages; })
    (import ./rustup { inherit packages; })
    (import ./android-tools { inherit packages; })
    (import ./password-store { inherit packages; })
    (import ./w3m { inherit packages; })
    (import ./1password { inherit packages inputs; })
    (import ./vagrant { inherit packages; })
    (import ./aerospace { inherit packages; })
    (import ./vscode { inherit packages; })
    (import ./antigravity-ide { inherit packages; })
    (import ./google-chrome { inherit packages; })
    (import ./aquaskk { inherit packages; })
    (import ./skimpdf { inherit packages; })
    dbeaver
    zotero
    (import ./postman { inherit packages; })
    raycast
    (import ./claude-desktop { inherit packages; })
    (import ./xcode { inherit packages; })
    (import ./ollama { inherit packages; })
    (import ./keynote { inherit packages; })
    (import ./numbers { inherit packages; })
    (import ./pages { inherit packages; })
    (import ./mcp-grafana { inherit packages; })
    (import ./helm { inherit packages; })
    (import ./argocd { inherit packages; })
    (import ./google-cloud-sdk { inherit packages; })
    (import ./gws { inherit packages; })
    (import ./agent-browser { inherit packages; })
    (import ./hermes-agent { inherit packages; })
  ];
in
{
  homeManagerImports = default.mkHomeManagerImports { inherit programs; };
  nixDarwinModules = default.mkNixDarwinModules { inherit programs; };
  nixosModules = default.mkNixosModules { inherit programs; };

  program-packages = {
    dbeaver = dbeaver.package;
    zotero = zotero.package;
    raycast = raycast.package;
  };
}
