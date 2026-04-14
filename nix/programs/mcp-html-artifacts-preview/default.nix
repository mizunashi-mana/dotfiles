{
  packages,
  ...
}:
let
  mcp-html-artifacts-preview = packages.mcp-html-artifacts-preview;
  claude = packages.claude-code;
in
{
  homeManagerImports = [
    (
      { lib, ... }:
      {
        home.packages = [
          mcp-html-artifacts-preview
        ];

        home.activation.claudeMcpHtmlArtifactsPreview = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [[ ! -x "${claude}/bin/claude" ]]; then
            verboseEcho "claude not found, skipping MCP server registration for html-artifacts-preview"
          elif "${claude}/bin/claude" mcp get html-artifacts-preview > /dev/null 2>&1; then
            verboseEcho "MCP server html-artifacts-preview already registered, skipping"
          else
            run "${claude}/bin/claude" mcp add --scope user -t stdio html-artifacts-preview -- "${mcp-html-artifacts-preview}/bin/mcp-html-artifacts-preview"
          fi
        '';
      }
    )
  ];
}
