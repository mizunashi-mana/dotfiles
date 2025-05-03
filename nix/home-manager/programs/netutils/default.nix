{ pkgs, ... }: {
  home.packages = [
    pkgs.inetutils
    pkgs.cacert

    pkgs.arp-scan
    pkgs.curl
    pkgs.nmap
    pkgs.wget
    pkgs.w3m
  ];
}
