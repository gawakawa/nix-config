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
      # Completion (Phase 2B)
      nvim_cmp
      cmp_nvim_lsp
      cmp_buffer
      cmp_path
      cmp_cmdline
      cmp_luasnip
      luasnip
      # File Navigation (Phase 2C)
      telescope_nvim
      plenary_nvim
      neo_tree_nvim
      nui_nvim
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
