{
  lib,
  callPackage,
  ...
}:
let
  buildNodePkg = callPackage ./node-pkgs/build-node-pkg.nix { };
in
buildNodePkg {
  pname = "mcp-html-artifacts-preview";
  npmRoot = ./node-pkgs/mcp-html-artifacts-preview;
  meta = {
    description = "MCP server for HTML artifacts preview";
    homepage = "https://github.com/mizunashi-mana/mcp-html-artifacts-preview";
    license = with lib.licenses; [
      asl20
      mpl20
    ];
    mainProgram = "mcp-html-artifacts-preview";
  };
}
