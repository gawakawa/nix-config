{ pkgs, ... }:
let
  terminal-browser = pkgs.callPackage ../../../hosts/nixos/packages/terminal-browser.nix { };
in
{
  home.file.".claude/skills/terminal-browser".source =
    "${terminal-browser}/share/terminal-browser/skills/default/terminal-browser";
}
