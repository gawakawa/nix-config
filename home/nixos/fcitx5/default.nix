{ pkgs, config, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [ pkgs.fcitx5-skk ];
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "skk";
        };
        "Groups/0/Items/0".Name = "skk";
      };
    };
  };

  xdg.dataFile."fcitx5/skk/dictionary_list".text = ''
    type=file,file=${config.xdg.dataHome}/fcitx5/skk/user.dict,mode=readwrite
    type=file,file=${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L,mode=readonly
  '';
}
