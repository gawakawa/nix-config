{
  home.file =
    let
      skills = builtins.readDir ./skills;
      mkSkill = name: {
        name = ".agents/skills/${name}";
        value = {
          source = ./skills/${name};
        };
      };
    in
    builtins.listToAttrs (map mkSkill (builtins.attrNames skills));
}
