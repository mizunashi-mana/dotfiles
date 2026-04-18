{
  packages,
  ...
}:
let
  playwright-mcp = packages.playwright-mcp;
  claude = packages.claude-code;
in
{
  homeManagerImports = [
    (
      { lib, ... }:
      {
        home.packages = [
          playwright-mcp
        ];

        home.activation.claudeMcpPlaywright = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [[ ! -x "${claude}/bin/claude" ]]; then
            verboseEcho "claude not found, skipping MCP server registration for playwright"
          elif "${claude}/bin/claude" mcp get playwright > /dev/null 2>&1; then
            verboseEcho "MCP server playwright already registered, skipping"
          else
            run "${claude}/bin/claude" mcp add --scope user -t stdio playwright -- "${playwright-mcp}/bin/playwright-mcp"
          fi
        '';
      }
    )
  ];
}
