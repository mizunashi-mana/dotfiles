{
  pkgs,
  ...
}:
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
      ];
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = true;
    };
  };
}
