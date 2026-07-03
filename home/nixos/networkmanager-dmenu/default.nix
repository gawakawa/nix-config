{ pkgs, ... }:
{
  home.packages = [ pkgs.networkmanager_dmenu ];

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = wofi --dmenu
  '';
}
