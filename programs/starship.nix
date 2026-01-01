let
  # Powerline symbols
  cap = ""; # U+E0B6 left half circle
  arrow = ""; # U+E0B0 solid right arrow

  # Directory icons
  iconDocs = "󰈙";
  iconDownloads = "";
  iconMusic = "";
  iconPictures = "";

  # Git
  gitBranchSymbol = "";
in
{
  programs.starship = {
    enable = true;
    settings = {
      format = "[${cap}](#3B2346)$directory[${arrow}](fg:#3B2346 bg:#4A2C3A)$git_branch$git_status$git_metrics[${arrow}](fg:#4A2C3A bg:#2A3D4A)$cmd_duration[${arrow}](fg:#2A3D4A)$line_break$character";

      add_newline = true;

      os = {
        style = "fg:#E0DEF4 bg:#3B2346";
        disabled = true;
      };

      directory = {
        style = "fg:#E0DEF4 bg:#3B2346";
        format = "[ $path ]($style)";
        truncation_length = 0;
        truncate_to_repo = false;
        substitutions = {
          "Documents" = "${iconDocs} ";
          "Downloads" = "${iconDownloads} ";
          "Music" = "${iconMusic} ";
          "Pictures" = "${iconPictures} ";
        };
      };

      git_branch = {
        symbol = gitBranchSymbol;
        style = "fg:#F0B8C4 bg:#4A2C3A";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "fg:#F0B8C4 bg:#4A2C3A";
        format = "[$all_status$ahead_behind ]($style)";
      };

      git_metrics = {
        disabled = false;
        added_style = "fg:#F0B8C4 bg:#4A2C3A";
        deleted_style = "fg:#F0B8C4 bg:#4A2C3A";
        format = "[ +$added/-$deleted ]($added_style)";
      };

      cmd_duration = {
        style = "fg:#A8D5F5 bg:#2A3D4A";
        format = "[ $duration ]($style)";
      };

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };
    };
  };
}
