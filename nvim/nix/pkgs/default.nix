{ pkgs }:

{
  # Import custom plugins
  vim-plugins = import ./vim-plugins { inherit pkgs; };
}
