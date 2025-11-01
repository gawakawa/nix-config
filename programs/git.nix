{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "gawakawa";
        email = "mashurakiryu@icloud.com";
      };
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
      };

      pull.rebase = "false";
    };
  };
}
