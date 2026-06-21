{
  pkgs,
  lib,
  config,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  xdg.configFile."gwq/config.toml".source = tomlFormat.generate "gwq-config.toml" {
    worktree = {
      basedir = config.programs.git.settings.ghq.root;
      auto_mkdir = true;
    };
    naming = {
      template = "{{.Host}}/{{.Owner}}/{{.Repository}}={{.Branch}}";
      sanitize_chars = {
        "/" = "-";
        ":" = "-";
      };
    };
    finder.preview = true;
    ui = {
      icons = true;
      tilde_home = true;
    };
    cd = {
      launch_shell = false;
      auto_cd_on_add = false;
    };
  };

  programs.zsh.initContent = lib.mkAfter ''
    source <(gwq completion zsh)
  '';
}
