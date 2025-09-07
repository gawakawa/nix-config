{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      directory = {
        truncation_length = 0;
        truncate_to_repo = false;

      };

      git_branch = {
        symbol = "  ";
        truncation_length = 4;
        truncation_symbol = "";
        format = "[$symbol$branch(:$remote_branch)](bold purple)";
      };

      git_status = {
        style = "fg:#7dcfff";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "✓";
        modified = "!\${count}";
        staged = "[++\($count\)](fg:#73daca)";
        format = "([\\[$all_status\$ahead\$behind\\]]($style))";
      };

      git_metrics = {
        disabled = false;
        added_style = "bold green";
        deleted_style = "bold red";
        format = "([+$added]($added_style))[/](bold cyan)([-$deleted]($deleted_style) )";
      };

      cmd_duration = {
        style = "bold red";
        format = "[ $duration](bold yellow) ";
      };

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };

      format = "$directory$git_branch $git_status$git_metrics$cmd_duration\n$character";
    };
  };
}
