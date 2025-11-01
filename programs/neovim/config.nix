{
  plugins,
  lib,
  stdenv,
}:

let
  # Environment variables for substitution
  # Only include minimal plugins for now
  envVars = {
    inherit (plugins)
      lazy_nvim
      tokyonight_nvim
      lualine_nvim
      nvim_web_devicons
      ;
  };

in
stdenv.mkDerivation {
  name = "neovim-config";

  # Source is the nvim directory (relative to nix-config root)
  # Using ./. to get the parent directory (nix-config root)
  src = ../../nvim;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/

    # Substitute all placeholders
    for file in $(find $out -type f -name "*.lua"); do
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: ''
          substituteInPlace "$file" --replace-warn "@${name}@" "${value}"
        '') envVars
      )}
    done
  '';
}
