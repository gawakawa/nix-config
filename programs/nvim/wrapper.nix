{
  pkgs,
  extraPackages ? [ ],
}:

let
  plugins = import ./plugins { inherit pkgs; };
  nvimConfig = pkgs.callPackage ./config.nix { inherit plugins; };
in
pkgs.writeShellScriptBin "nvim" ''
  export PATH=$PATH:${pkgs.lib.makeBinPath extraPackages}
  export MY_CONFIG_PATH=${nvimConfig}
  exec ${pkgs.neovim-unwrapped}/bin/nvim -u ${nvimConfig}/init.lua "$@"
''
