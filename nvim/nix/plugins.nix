{ pkgs }:

let
  # Import all plugins from vim-plugins
  pluginList = import ./pkgs/vim-plugins { inherit pkgs; };

  # Import custom lazy.nvim
  lazyNvimCustom = pkgs.callPackage ./pkgs/vim-plugins/lazy-nvim.nix { };

  # Normalize plugin name to placeholder format
  # e.g., "nvim-treesitter" -> "nvim_treesitter"
  # e.g., "neo-tree.nvim" -> "neo_tree_nvim"
  normalizePname = pname: builtins.replaceStrings [ "-" "." ] [ "_" "_" ] (pkgs.lib.toLower pname);

  # Convert plugin list to attribute set
  pkgListToAttr =
    pkgList:
    pkgs.lib.foldl' (
      acc: pkg:
      let
        pname = pkg.pname or pkg.name;
      in
      acc // { "${normalizePname pname}" = pkg; }
    ) { } pkgList;

  # Convert plugins to attribute set
  pluginsAttrSet = pkgListToAttr pluginList;

in
# Merge plugins with custom lazy_nvim
pluginsAttrSet
// {
  lazy_nvim = lazyNvimCustom;
}
