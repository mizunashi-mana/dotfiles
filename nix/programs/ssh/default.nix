{
  ...
}:
{
  homeManagerImports = [
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = { };
        };
        extraConfig = builtins.readFile ./ssh.conf;
      };

      home.file = {
        ".ssh/conf.d/common-hosts.conf" = {
          text = builtins.readFile ./conf.d/common-hosts.conf;
        };
        ".ssh/ppkey/.keep" = {
          text = "";
        };
      };
    }
  ];
}
