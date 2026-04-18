{
  lib,
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "playwright-cli";
  version = "0.1.8";

  src = fetchurl {
    url = "https://registry.npmjs.org/@playwright/cli/-/cli-${version}.tgz";
    hash = "sha256-7UJSZ3Kwzn93e4b2wAcB/j9a5VupgOUR4f0us31PfaQ=";
  };

  postPatch = ''
    cp ${./playwright-cli-package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-RF+PkEKyzotIOAAgPFoPdGXMjChGnZq8CGGCriaSi7s=";

  dontNpmBuild = true;

  meta = {
    description = "Playwright CLI for browser management";
    homepage = "https://playwright.dev/";
    license = lib.licenses.asl20;
    mainProgram = "playwright-cli";
  };
}
