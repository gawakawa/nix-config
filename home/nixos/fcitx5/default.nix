{
  lib,
  pkgs,
  config,
  ...
}:
let
  # Flip once comfortable with SKK; it replaces mozc entirely.
  useSkk = false;
  im = if useSkk then "skk" else "mozc";
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [ (if useSkk then pkgs.fcitx5-skk else pkgs.fcitx5-mozc) ];
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = im;
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = im;
      };
    };
  };

  xdg.dataFile = lib.optionalAttrs useSkk {
    "fcitx5/skk/dictionary_list".text = ''
      type=file,file=${config.xdg.dataHome}/fcitx5/skk/user.dict,mode=readwrite
      type=file,file=${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L,mode=readonly
    '';
  };
}
