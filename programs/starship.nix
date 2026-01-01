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
      format = "[${cap}](#9A348E)$directory[${arrow}](fg:#9A348E bg:#DA627D)$git_branch$git_status[${arrow}](fg:#DA627D bg:#FCA17D)$git_metrics[${arrow}](fg:#FCA17D bg:#86BBD8)$cmd_duration[${arrow}](fg:#86BBD8)$line_break$character";

      add_newline = true;

      os = {
        style = "bg:#9A348E";
        disabled = true;
      };

      directory = {
        style = "bg:#9A348E";
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
        style = "bg:#DA627D";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:#DA627D";
        format = "[$all_status$ahead_behind ]($style)";
      };

      git_metrics = {
        disabled = false;
        added_style = "bg:#FCA17D";
        deleted_style = "bg:#FCA17D";
        format = "[ +$added/-$deleted ]($added_style)";
      };

      cmd_duration = {
        style = "bg:#86BBD8";
        format = "[ $duration ]($style)";
      };

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };
    };
  };
}
