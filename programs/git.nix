{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "gawakawa";
    userEmail = "mashurakiryu@icloud.com";

    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
      };

      pull.rebase = "false";
    };
  };
}
