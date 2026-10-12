{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  inherit (pkgs.callPackage ./source.nix { }) version;

  target = stdenv.hostPlatform.rust.rustcTarget;
  # The release binaries are built against this channel; rustowlc links its librustc_driver
  toolchainChannel = "1.95.0";
  toolchain = pkgs.rust-bin.stable.${toolchainChannel}.minimal;
  toolchainName = "${toolchainChannel}-${target}";

  hashes = {
    x86_64-unknown-linux-gnu = "sha256-BUyJR7q/OLmGjiBDGxCSBP8ihkrklnPQ4JZ4R9bXZ5o=";
    aarch64-apple-darwin = "sha256-Qq7FrFgRmdjFkhDqmkvnfToVhk7vAcb6mZh6ypu+t4w=";
  };
in
stdenv.mkDerivation {
  pname = "rustowl";
  inherit version;

  src = fetchurl {
    url = "https://github.com/cordx56/rustowl/releases/download/v${version}/rustowl-${target}.tar.gz";
    hash = hashes.${target};
  };
  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ toolchain ];

  # Stripping would invalidate the ad-hoc signature of the darwin binaries
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    # rustowl looks for sysroot/ next to its executable
    sysroot=$out/bin/sysroot/${toolchainName}
    mkdir -p $sysroot/bin
    install -m755 rustowl $out/bin/rustowl
    install -m755 sysroot/${toolchainName}/bin/rustowlc $sysroot/bin/

    for d in lib libexec share; do
      if [ -e ${toolchain}/$d ]; then
        ln -s ${toolchain}/$d $sysroot/$d
      fi
    done
    for f in ${toolchain}/bin/*; do
      ln -s "$f" $sysroot/bin/
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Visualize Ownership and Lifetimes in Rust";
    homepage = "https://github.com/cordx56/rustowl";
    license = licenses.mpl20;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "rustowl";
  };
}
