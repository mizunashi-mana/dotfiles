{
  lib,
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.70";

  src = fetchurl {
    url = "https://registry.npmjs.org/@playwright/mcp/-/mcp-${version}.tgz";
    hash = "sha256-9LHDHkvOfm7PK0gwlxVf+roYTma/CrI1+Z8RhRtl3nI=";
  };

  postPatch = ''
    cp ${./playwright-mcp-package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-ofMIJHI77upkZxnyEOt/VPhGn6YLcR+Jwjos6Vz6leU=";
  npmDepsFetcherVersion = 2;
  dontNpmBuild = true;

  meta = {
    description = "Playwright MCP server";
    homepage = "https://github.com/Microsoft/playwright-mcp";
    license = lib.licenses.asl20;
    mainProgram = "mcp-server-playwright";
  };
}
