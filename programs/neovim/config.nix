{
  plugins,
  lib,
  stdenv,
}:

let
  # Environment variables for substitution
  envVars = {
    inherit (plugins)
      lazy_nvim
      tokyonight_nvim
      lualine_nvim
      nvim_web_devicons
      # LSP (Phase 2A)
      mason_nvim
      mason_lspconfig_nvim
      nvim_lspconfig
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
