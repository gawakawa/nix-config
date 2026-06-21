{ config, ... }:
{
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/projects/github.com/gawakawa/password-store";
    };
  };
}
