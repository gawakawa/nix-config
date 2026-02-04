{
  pkgs,
  lib,
  makeRustPlatform,
}:

let
  version = "1.0.0-rc.1";

  src = pkgs.fetchFromGitHub {
    owner = "cordx56";
    repo = "rustowl";
    rev = "v${version}";
    hash = "sha256-CXuwbg39sboKxuJTNpq3KVqjTTOQp1Af4XWZLjorHdM=";
  };

  toolchain = pkgs.rust-bin.fromRustupToolchainFile "${src}/rust-toolchain.toml";
  toolchainTOML = lib.importTOML "${src}/rust-toolchain.toml";
  toolchainName = "${toolchainTOML.toolchain.channel}-${pkgs.stdenv.hostPlatform.rust.rustcTarget}";
  rustPlatform = makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
rustPlatform.buildRustPackage {
  pname = "rustowl";
  inherit version src;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    toolchain
    pkgs.pkg-config
  ];

  buildInputs = [ pkgs.zlib ];

  RUSTOWL_TOOLCHAIN = toolchainTOML.toolchain.channel;
  RUSTUP_TOOLCHAIN = toolchainName;

  postInstall = ''
    # Create sysroot structure in bin/ directory (rustowl looks for sysroot/ next to executable)
    mkdir -p $out/bin/sysroot/${toolchainName}/bin

    # Link toolchain directories
    ln -s ${toolchain}/lib $out/bin/sysroot/${toolchainName}/lib
    ln -s ${toolchain}/libexec $out/bin/sysroot/${toolchainName}/libexec
    ln -s ${toolchain}/share $out/bin/sysroot/${toolchainName}/share

    # Link toolchain binaries and add rustowlc
    for f in ${toolchain}/bin/*; do
      ln -s "$f" $out/bin/sysroot/${toolchainName}/bin/
    done
    cp $out/bin/rustowlc $out/bin/sysroot/${toolchainName}/bin/
  '';

  meta = with lib; {
    description = "Visualize Ownership and Lifetimes in Rust";
    homepage = "https://github.com/cordx56/rustowl";
    license = licenses.mpl20;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "rustowl";
  };
}
