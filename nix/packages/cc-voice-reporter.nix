{
  lib,
  buildNpmPackage,
  fetchurl,
  jq,
}:
buildNpmPackage rec {
  pname = "cc-voice-reporter";
  version = "2.2.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mizunashi_mana/cc-voice-reporter/-/cc-voice-reporter-${version}.tgz";
    hash = "sha256-nhG1fFWqzWHPOrlTL7r0GML3pfHmIPIV3wDa3YWRtsE=";
  };

  postPatch = ''
    cp ${./cc-voice-reporter-package-lock.json} package-lock.json
    ${lib.getExe jq} 'del(.devDependencies) | del(.scripts.prepack)' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-XIr8BFhCp0gNDb9KJpvMOaRlHx88IwScvQUAg2G+Bbo=";
  npmDepsFetcherVersion = 2;
  dontNpmBuild = true;

  meta = {
    description = "Claude Code voice reporter";
    homepage = "https://github.com/mizunashi-mana/cc-voice-reporter";
    license = lib.licenses.mpl20;
    mainProgram = "cc-voice-reporter";
  };
}
