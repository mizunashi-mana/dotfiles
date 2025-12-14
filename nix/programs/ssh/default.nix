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
        ".ssh/ppkey/.keep" = {
          text = "";
        };
        ".ssh/conf.d/common-hosts.conf" = {
          text = builtins.readFile ./conf.d/common-hosts.conf;
        };
        ".ssh/conf.d/colima.conf" = {
          text = builtins.readFile ./conf.d/colima.conf;
        };
      };
    }
  ];
}
