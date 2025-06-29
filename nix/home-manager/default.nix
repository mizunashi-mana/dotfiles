{
  packages,
  default-editor ? "emacsclient -nw --alternate-editor 'nvim'",
  ...
}:
{
  imports = [
    (import ./editorconfig {
      inherit packages;
    })
    (import ./home {
      inherit packages default-editor;
    })
    (import ./programs {
      inherit packages;
    })
  ];
}
