{ pkgs, ... }: {
  programs.ssh = {
    enable = true;
    extraConfig = builtins.readFile ./ssh.conf;
  };

  home.file = {
    ".ssh/conf.d/common-hosts.conf" = {
      text = builtins.readFile ./conf.d/common-hosts.conf;
    };
  };
}
