{
  pkgs,
  plugins,
  tools ? [ ],
  vscode-lean4,
}:

let
  # Fetch Lean abbreviations and convert to Lua table
  leanAbbreviations = pkgs.stdenv.mkDerivation {
    name = "lean-abbreviations";

    # Use flake input instead of fetchurl for automatic updates via `nix flake update`
    src = "${vscode-lean4}/lean4-unicode-input/src/abbreviations.json";

    nativeBuildInputs = [ pkgs.jq ];
    dontUnpack = true;

    buildPhase = ''
      # JSON → Lua table conversion
      # $CURSOR entries are handled by LuaSnip insert nodes at runtime
      ${pkgs.jq}/bin/jq -r '
        to_entries
        | map("  [" + ("\\"+.key | @json) + "] = " + (.value | @json))
        | "return {\n" + join(",\n") + "\n}"
      ' < $src > lean_abbreviations.lua
    '';

    installPhase = ''
      mkdir -p $out
      cp lean_abbreviations.lua $out/
    '';
  };

  # Build treesitter parsers string
  treesitterParsers =
    let
      nvimTreesitter = plugins.nvim_treesitter;
    in
    pkgs.lib.concatStringsSep "," (map (parser: "${parser}") nvimTreesitter.dependencies);

  # Environment variables for placeholder substitution
  envVars = plugins // {
    treesitter_parsers = treesitterParsers;
  };

  # Build Neovim config derivation with placeholder substitution
  nvimConfig = pkgs.stdenv.mkDerivation (
    envVars
    // {
      pname = "neovim-config";
      version = "latest";

      src = ../../nvim;

      installPhase = ''
        mkdir -p $out

        # Copy all files
        cp -r $src/* $out/

        # Ensure write permissions for creating new directories
        chmod -R u+w $out

        # Copy Lean abbreviations
        mkdir -p $out/lua/data
        cp ${leanAbbreviations}/lean_abbreviations.lua $out/lua/data/

        # Substitute all placeholders in all files
        for file in $(find $out -type f); do
          substituteAllInPlace "$file"
        done
      '';
    }
  );

in
# Create wrapper script
pkgs.writeShellScriptBin "nvim" ''
  export PATH=$PATH:${pkgs.lib.makeBinPath tools}
  export MY_CONFIG_PATH=${nvimConfig}
  exec ${pkgs.neovim-unwrapped}/bin/nvim -u ${nvimConfig}/init.lua "$@"
''
