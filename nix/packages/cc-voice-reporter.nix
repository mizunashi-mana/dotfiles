{
  lib,
  callPackage,
  ...
}:
let
  buildNodePkg = callPackage ./node-pkgs/build-node-pkg.nix { };
in
buildNodePkg {
  pname = "cc-voice-reporter";
  npmRoot = ./node-pkgs/cc-voice-reporter;
  meta = {
    description = "Claude Code voice reporter";
    homepage = "https://github.com/mizunashi-mana/cc-voice-reporter";
    license = with lib.licenses; [
      asl20
      mpl20
    ];
    mainProgram = "cc-voice-reporter";
  };
}
