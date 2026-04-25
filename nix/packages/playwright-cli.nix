{
  lib,
  callPackage,
  ...
}:
let
  buildNodePkg = callPackage ./node-pkgs/build-node-pkg.nix { };
in
buildNodePkg {
  pname = "playwright-cli";
  npmRoot = ./node-pkgs/playwright-cli;
  meta = {
    description = "Playwright CLI for browser management";
    homepage = "https://playwright.dev/";
    license = lib.licenses.asl20;
    mainProgram = "playwright-cli";
  };
}
