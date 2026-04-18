{
  lib,
  buildNpmPackage,
  fetchurl,
  jq,
}:
buildNpmPackage rec {
  pname = "mcp-html-artifacts-preview";
  version = "1.0.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mizunashi_mana/mcp-html-artifacts-preview/-/mcp-html-artifacts-preview-${version}.tgz";
    hash = "sha256-kqVczGrNKheV8R8bqyBCLMUbsldOGqZs3Y7NF9fJvgY=";
  };

  postPatch = ''
    cp ${./mcp-html-artifacts-preview-package-lock.json} package-lock.json
    ${lib.getExe jq} 'del(.devDependencies) | del(.scripts.prepack)' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-wMrEFPm5gi6PAdNkkN+IY+3BjMxV2l/2qXCqYcZv7YU=";
  npmDepsFetcherVersion = 2;
  dontNpmBuild = true;

  meta = {
    description = "MCP server for HTML artifacts preview";
    homepage = "https://github.com/mizunashi-mana/mcp-html-artifacts-preview";
    license = lib.licenses.mpl20;
    mainProgram = "mcp-html-artifacts-preview";
  };
}
