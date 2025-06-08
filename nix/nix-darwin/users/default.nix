{
  packages,
  username,
  homedir,
  ...
}:
{
  users = {
    users.${username} = {
      home = homedir;
      shell = packages.pkgs.fish;
      ignoreShellProgramCheck = true;
    };
  };
}
