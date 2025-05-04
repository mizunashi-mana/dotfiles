{ pkgs, username, homedir }: {
  users = {
    users.${username} = {
      home = homedir;
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
    };
  };
}
