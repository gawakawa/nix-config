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

  # Exit 1 when the lint score is below the threshold; lint errors exit 2.
  yomiyasu-gate = pkgs.writeShellApplication {
    name = "yomiyasu-gate";
    runtimeInputs = [
      pkgs.python3
      pkgs.jq
    ];
    text = ''
      lint=${yomiyasu}/scripts/yomiyasu_lint.py
      text=$(cat "''${1:-/dev/stdin}")
      score=$(printf '%s' "$text" | python3 "$lint" --json | jq .score)
      printf '%s' "$text" | python3 "$lint"
      (( score >= 90 ))
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
