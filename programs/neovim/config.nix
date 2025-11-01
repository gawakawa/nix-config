{
  plugins,
  lib,
  stdenv,
}:

let
  # Treesitter parsers path (Phase 4)
  treesitterParsers =
    let
      nvimTreesitter = plugins.nvim_treesitter;
    in
    lib.concatStringsSep "," (map (parser: "${parser}") nvimTreesitter.dependencies);

  # Environment variables for substitution
  # Following asa1984.nvim pattern: pass all plugins as environment variables
  envVars = plugins // {
    # Special paths
    treesitter_parsers = treesitterParsers;
  };

in
# Pass envVars as attributes to mkDerivation for substituteAllInPlace
stdenv.mkDerivation (
  envVars
  // {
    pname = "neovim-config";
    version = "latest";

    # Source is the nvim directory (relative to nix-config root)
    src = ../../nvim;

    installPhase = ''
      mkdir -p $out

      # Substitute all @placeholder@ with environment variables
      for file in $(find . -type f); do
        substituteAllInPlace "$file"
      done

      # Copy to output
      cp -r ./ $out
    '';
  }
)
