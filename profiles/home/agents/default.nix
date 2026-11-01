{
  inputs,
  system,
  pkgs,
  ...
}:
let
  yomiyasu = pkgs.runCommand "yomiyasu-skill" { } ''
    mkdir -p "$out"
    cp -r ${inputs.yomiyasu}/skills/yomiyasu/{SKILL.md,references,scripts,LICENSE,UNICODE-LICENSE.txt} "$out/"
  '';

  # Exit 1 when lint reports warn or error findings; lint errors exit 2 or 3.
  yomiyasu-gate = pkgs.writeShellApplication {
    name = "yomiyasu-gate";
    runtimeInputs = [ pkgs.python3 ];
    text = ''
      python3 ${yomiyasu}/scripts/yomiyasu_lint.py --fail-on warn "$@"
    '';
  };

  skills = builtins.readDir ./skills;
  mkSkill = name: {
    name = ".agents/skills/${name}";
    value = {
      source = ./skills/${name};
    };
  };
in
{
  home.packages = [
    pkgs.python3
    inputs.git-surgeon.packages.${system}.default
    yomiyasu-gate
  ];

  home.file = builtins.listToAttrs (map mkSkill (builtins.attrNames skills)) // {
    ".agents/skills/yomiyasu".source = yomiyasu;
    ".claude/skills/yomiyasu".source = yomiyasu;
    ".agents/skills/git-surgeon".source = "${inputs.git-surgeon}/skills/git-surgeon";
    ".claude/skills/git-surgeon".source = "${inputs.git-surgeon}/skills/git-surgeon";
  };
}
