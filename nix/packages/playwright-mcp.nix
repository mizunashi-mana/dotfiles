{
  lib,
  callPackage,
  ...
}:
let
  buildNodePkg = callPackage ./node-pkgs/build-node-pkg.nix { };
in
buildNodePkg {
  pname = "playwright-mcp";
  npmRoot = ./node-pkgs/playwright-mcp;
  meta = {
    description = "Playwright MCP server";
    homepage = "https://github.com/Microsoft/playwright-mcp";
    license = lib.licenses.asl20;
    mainProgram = "playwright-mcp";
  };
}
