{ packages, ... }:
{
  imports = [
    (import ./editorconfig {
      inherit packages;
    })
    (import ./home {
      inherit packages;
    })
    (import ./programs {
      inherit packages;
    })
  ];
}
