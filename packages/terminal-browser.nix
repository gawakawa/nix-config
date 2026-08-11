{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  addDriverRunpath,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  xorg,
}:
let
  version = "0.5.3";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/zenbu-labs/terminal-browser/releases/download/v${version}/terminal-browser-linux-x64.tar.gz";
      hash = "sha256-Bdzl6QmiDixO/W+i9eZFiyYZC+NxOeXCl97r4xHEmqs=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/zenbu-labs/terminal-browser/releases/download/v${version}/terminal-browser-darwin-arm64.tar.gz";
      hash = "sha256-avEqAt+SAVAF0CD2qW2T+fvvWHlDamnQGVLdTCzxQ8o=";
    };
  };
in
stdenv.mkDerivation {
  pname = "terminal-browser";
  inherit version;

  src =
    srcs.${stdenv.hostPlatform.system}
      or (throw "terminal-browser: no build for ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    addDriverRunpath
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];

  # Bundled electron binary depends on the sibling libffmpeg.so.
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    addAutoPatchelfSearchPath "$out/share/terminal-browser/electron"
  '';

  # Offscreen GPU rendering is the app's core mechanism.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    addDriverRunpath "$out/share/terminal-browser/electron/electron"
  '';

  # Prebuilt Chromium/Electron blob; stripping is slow, and on Darwin it
  # would invalidate the app bundle's code signature.
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
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "terminal-browser";
  };
}
