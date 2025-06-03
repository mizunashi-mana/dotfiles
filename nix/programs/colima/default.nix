{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        pkgs.colima
      ];
    }
  ];

  nixDarwinModules = [
    {
      launchd.user.agents.colima = {
        environment = {
          PATH = "/bin:/usr/bin:${pkgs.docker}/bin";
        };
        serviceConfig = {
          ProgramArguments = [
            "${pkgs.colima}/bin/colima"
            "start"
            "--foreground"
            "--vm-type"
            "vz"
            "--cpu"
            "4"
            "--memory"
            "8"
          ];
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = true;
        };
      };
    }
  ];
}
