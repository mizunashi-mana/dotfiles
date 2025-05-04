{ pkgs, username, homedir }: {
  environment = {
    systemPackages = [
      pkgs.fish
    ];

    shells = [
      pkgs.fish
    ];
  };
}
