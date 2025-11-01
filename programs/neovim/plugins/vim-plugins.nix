{ pkgs, ... }:

# Minimal plugin set for initial testing
# More plugins will be added after basic functionality is verified
with pkgs.vimPlugins;
[
  # Core / UI
  tokyonight-nvim
  lualine-nvim
  nvim-web-devicons
]
