{ inputs, pkgs, ... }:
{
  home.packages = [ pkgs.python3 ];

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
    };
}
