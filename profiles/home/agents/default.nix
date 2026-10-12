{
  inputs,
  system,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.python3
    inputs.git-surgeon.packages.${system}.default
  ];

  home.file =
    let
      yomiyasu = pkgs.runCommand "yomiyasu-skill" { } ''
        mkdir -p "$out"
        cp -r ${inputs.yomiyasu}/skills/yomiyasu/{SKILL.md,references,scripts,LICENSE,UNICODE-LICENSE.txt} "$out/"
      '';
      skills = builtins.readDir ./skills;
      mkSkill = name: {
        name = ".agents/skills/${name}";
        value = {
          source = ./skills/${name};
        };
      };
    in
    builtins.listToAttrs (map mkSkill (builtins.attrNames skills))
    // {
      ".agents/skills/yomiyasu".source = yomiyasu;
      ".claude/skills/yomiyasu".source = yomiyasu;
      ".agents/skills/git-surgeon".source = "${inputs.git-surgeon}/skills/git-surgeon";
      ".claude/skills/git-surgeon".source = "${inputs.git-surgeon}/skills/git-surgeon";
    };
}
