{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "cc-voice-reporter";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mizunashi-mana";
    repo = "cc-voice-reporter";
    tag = "v${version}";
    hash = "sha256-yCsomcak2RsvXDlGdkWCKjoTHiHWXXICqj7dYvXHEGg=";
  };

  npmDepsHash = "sha256-0QHOtajzCpLlv8VXz0p//654dEaxVSkoRg5rbbLAr2M=";

  npmWorkspace = "packages/cc-voice-reporter";

  postBuild = ''
    cp LICENSE LICENSE.Apache-2.0.txt LICENSE.MPL-2.0.txt packages/cc-voice-reporter/
  '';

  dontNpmPrune = true;

  postInstall = ''
    rm -f "$out/lib/node_modules/cc-voice-reporter-root/node_modules/@mizunashi_mana/cc-voice-reporter"
    rm -f "$out/lib/node_modules/cc-voice-reporter-root/node_modules/@cc-voice-reporter/eslint-config"
  '';

  meta = {
    description = "Claude Code voice reporter";
    homepage = "https://github.com/mizunashi-mana/cc-voice-reporter";
    license = lib.licenses.mpl20;
    mainProgram = "cc-voice-reporter";
  };
}
