# Helper to build a CLI package from a node-pkgs subdirectory using importNpmLock
{
  lib,
  stdenv,
  importNpmLock,
  nodejs,
  makeBinaryWrapper,
}:
{
  pname,
  npmRoot,
  meta ? { },
}:
let
  packageJson = lib.importJSON (npmRoot + "/package.json");
  packageLock = lib.importJSON (npmRoot + "/package-lock.json");
  depName = builtins.head (builtins.attrNames packageJson.dependencies);
  version = packageLock.packages.${"node_modules/${depName}"}.version;

  nodeModules = importNpmLock.buildNodeModules {
    inherit npmRoot nodejs;
  };
in
stdenv.mkDerivation {
  inherit pname version meta;

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib
    cp -r ${nodeModules}/node_modules $out/lib/node_modules

    for bin in $out/lib/node_modules/.bin/*; do
      if [ -L "$bin" ]; then
        target=$(readlink -f "$bin")
        name=$(basename "$bin")
        makeWrapper "$target" "$out/bin/$name" \
          --set NODE_PATH "$out/lib/node_modules" \
          --prefix PATH : ${nodejs}/bin
      fi
    done

    runHook postInstall
  '';
}
