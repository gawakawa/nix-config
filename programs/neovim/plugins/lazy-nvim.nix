{
  pkgs,
  stdenv,
  vimUtils,
}:

let
  # Use nixpkgs lazy-nvim as base
  originalLazyNvim = pkgs.vimPlugins.lazy-nvim;

  # Replace vim.fn.stdpath("config") with vim.fn.expand("$MY_CONFIG_PATH")
  # This allows Nix to control the config location via environment variable
  modifiedSrc = stdenv.mkDerivation {
    name = "lazy.nvim-modified-src";
    src = originalLazyNvim.src;

    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/

      # Replace config path references
      for file in $(find $out -type f -name "*.lua"); do
        substituteInPlace "$file" \
          --replace-warn 'vim.fn.stdpath("config")' 'vim.fn.expand("$MY_CONFIG_PATH")'
      done
    '';
  };
in
vimUtils.buildVimPlugin {
  name = "lazy.nvim";
  src = modifiedSrc;
  doCheck = false; # Skip require check (we don't use plugin management features)
}
