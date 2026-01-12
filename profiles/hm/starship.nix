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

  # Duration
  iconDuration = "󱦟";
in
{
  programs.starship = {
    enable = true;
    settings = {
      format = "[${cap}](#1E3A5F)$directory[${arrow}](fg:#1E3A5F bg:#3B3366)$git_branch$git_status$git_metrics[${arrow}](fg:#3B3366 bg:#4A2040)$cmd_duration[${arrow}](fg:#4A2040)$line_break$character";

      add_newline = true;

      os = {
        style = "fg:#A8D5F5 bg:#1E3A5F";
        disabled = true;
      };

      directory = {
        style = "fg:#A8D5F5 bg:#1E3A5F";
        format = "[$path ]($style)";
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
        style = "fg:#D4BFFF bg:#3B3366";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "fg:#D4BFFF bg:#3B3366";
        format = "[$all_status$ahead_behind ]($style)";
      };

      git_metrics = {
        disabled = false;
        added_style = "fg:#D4BFFF bg:#3B3366";
        deleted_style = "fg:#D4BFFF bg:#3B3366";
        format = "[+$added/-$deleted ]($added_style)";
      };

      cmd_duration = {
        min_time = 0;
        style = "fg:#F5A8C8 bg:#4A2040";
        format = "[ ${iconDuration} $duration ]($style)";
      };

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };
    };
  };
}
