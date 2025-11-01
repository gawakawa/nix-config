{
  plugins,
  lib,
  stdenv,
}:

let
  treesitterParsers =
    let
      nvimTreesitter = plugins.nvim_treesitter;
    in
    lib.concatStringsSep "," (map (parser: "${parser}") nvimTreesitter.dependencies);

  envVars = plugins // {
    treesitter_parsers = treesitterParsers;
  };

in
stdenv.mkDerivation (
  envVars
  // {
    pname = "neovim-config";
    version = "latest";

    src = ../../nvim;

    installPhase = ''
      mkdir -p $out

      for file in $(find . -type f); do
        substituteAllInPlace "$file"
      done

      cp -r ./ $out
    '';
  }
)
