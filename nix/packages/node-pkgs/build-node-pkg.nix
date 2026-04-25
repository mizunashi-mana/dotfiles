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
  bins ? [ ],
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

  installPhase =
    let
      exportedBins = if bins != [ ] then bins else [ pname ];
    in
    ''
      runHook preInstall

      mkdir -p $out/bin $out/lib/${pname}
      cp -r ${nodeModules}/node_modules $out/lib/${pname}/node_modules

      ${lib.concatMapStringsSep "\n" (name: ''
        if [ -L "$out/lib/${pname}/node_modules/.bin/${name}" ]; then
          target=$(readlink -f "$out/lib/${pname}/node_modules/.bin/${name}")
          makeWrapper "$target" "$out/bin/${name}" \
            --set NODE_PATH "$out/lib/${pname}/node_modules" \
            --prefix PATH : ${nodejs}/bin
        else
          echo "WARNING: binary '${name}' not found in .bin/" >&2
        fi
      '') exportedBins}

      runHook postInstall
    '';
}
