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
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  pango,
  systemd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "terminal-browser";
  version = "0.5.3";

  src = fetchurl {
    url = "https://github.com/zenbu-labs/terminal-browser/releases/download/v${finalAttrs.version}/terminal-browser-linux-x64.tar.gz";
    hash = "sha256-Bdzl6QmiDixO/W+i9eZFiyYZC+NxOeXCl97r4xHEmqs=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    addDriverRunpath
  ];

  buildInputs = [
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
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
    systemd
  ];

  # Bundled electron binary depends on the sibling libffmpeg.so.
  preFixup = ''
    addAutoPatchelfSearchPath "$out/share/terminal-browser/electron"
  '';

  # Offscreen GPU rendering is the app's core mechanism.
  postFixup = ''
    addDriverRunpath "$out/share/terminal-browser/electron/electron"
  '';

  # Prebuilt Chromium/Electron blob; stripping is slow and not useful.
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
    platforms = [ "x86_64-linux" ];
    mainProgram = "terminal-browser";
  };
})
