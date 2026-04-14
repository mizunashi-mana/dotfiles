{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "mcp-html-artifacts-preview";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mizunashi-mana";
    repo = "mcp-html-artifacts-preview";
    tag = "v${version}";
    hash = "sha256-h+K6yDZVrUE6Vrkb97W2bgJHFNhcNfgdteyvunmo35s=";
  };

  npmDepsHash = "sha256-9Xv/IrLJGRz9WSDCSQa3p/lWUaXhevPfWqhlKsVVSSc=";

  npmWorkspace = "packages/mcp-html-artifacts-preview";

  postBuild = ''
    cp LICENSE LICENSE-APACHE LICENSE-MPL packages/mcp-html-artifacts-preview/
  '';

  dontNpmPrune = true;

  postInstall = ''
    rm -f "$out/lib/node_modules/mcp-html-artifacts-preview-root/node_modules/@mizunashi_mana/mcp-html-artifacts-preview"
    rm -f "$out/lib/node_modules/mcp-html-artifacts-preview-root/node_modules/@mcp-html-artifacts-preview/eslint-config"
  '';

  meta = {
    description = "MCP server for HTML artifacts preview";
    homepage = "https://github.com/mizunashi-mana/mcp-html-artifacts-preview";
    license = lib.licenses.mpl20;
    mainProgram = "mcp-html-artifacts-preview";
  };
}
