{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "terminal-browser";
  version = "0.5.3";

  src = fetchurl {
    url = "https://github.com/zenbu-labs/terminal-browser/releases/download/v${finalAttrs.version}/terminal-browser-darwin-arm64.tar.gz";
    hash = "sha256-avEqAt+SAVAF0CD2qW2T+fvvWHlDamnQGVLdTCzxQ8o=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  # Prebuilt, signed .app bundle; stripping would invalidate the signature.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/terminal-browser"
    cp -r . "$out/share/terminal-browser"

    # $0-relative path resolution in bin/terminal-browser requires a real
    # file next to its siblings, not a symlink from $out/bin.
    makeWrapper "$out/share/terminal-browser/bin/terminal-browser" "$out/bin/terminal-browser"

    runHook postInstall
  '';

  meta = {
    description = "A real browser that runs directly inside your existing terminal";
    homepage = "https://github.com/zenbu-labs/terminal-browser";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "aarch64-darwin" ];
    mainProgram = "terminal-browser";
  };
})
