{
  pkgs,
  ...
}:
let
  # Hyprland's built-in teardrop logo (extracted from Hyprland/assets/header.svg,
  # rotated -30deg to match the compositor's own fallback cursor), packaged as an
  # installable cursor theme in both hyprcursor (vector) and XCursor (raster) formats.
  cursorLogoSvg = ./hyprland-logo.svg;
  cursorDescription = "Hyprland's built-in teardrop logo, as an installable cursor theme";
  xcursorThemeName = "hyprland-logo";
  hyprcursorThemeName = "hyprland_logo";
  cursorSizes = [
    24
    32
    48
    64
    96
  ];
  # The size Hyprland actually runs with (XCURSOR_SIZE/HYPRCURSOR_SIZE below).
  # Must be a member of cursorSizes so the XCursor raster generated for it
  # exists exactly (no libXcursor fallback to the nearest available size).
  defaultCursorSize = 32;
  # Where in the (square) logo the pointer's "click point" sits, as a 0-1 fraction
  # of width/height. Single source of truth for both the hyprcursor meta.hl and the
  # XCursor xcursorgen.conf hotspots below.
  cursorHotspotXRatio = 0.230;
  cursorHotspotYRatio = 0.037;
  cursorSizesStr = pkgs.lib.concatMapStringsSep " " toString cursorSizes;
  xcursorgenConfLines = pkgs.lib.concatMapStringsSep "\n" (
    size:
    let
      x = builtins.floor (size * cursorHotspotXRatio + 0.5);
      y = builtins.floor (size * cursorHotspotYRatio + 0.5);
    in
    "${toString size} ${toString x} ${toString y} pngs/logo-${toString size}.png"
  ) cursorSizes;
  cursorTheme =
    pkgs.runCommand "hyprland-logo-cursor-theme"
      {
        nativeBuildInputs = [
          pkgs.resvg
          pkgs.xcursorgen
          pkgs.hyprcursor
        ];
      }
      ''
        mkdir -p hc-src/hyprcursors/left_ptr
        cp ${cursorLogoSvg} hc-src/hyprcursors/left_ptr/logo.svg

        cat > hc-src/manifest.hl <<'EOF'
        name = ${hyprcursorThemeName}
        description = ${cursorDescription}
        version = 0.1
        cursors_directory = hyprcursors
        EOF

        cat > hc-src/hyprcursors/left_ptr/meta.hl <<'EOF'
        resize_algorithm = bilinear
        hotspot_x = ${toString cursorHotspotXRatio}
        hotspot_y = ${toString cursorHotspotYRatio}
        define_override = arrow
        define_override = default
        define_override = left_ptr
        define_size = 32, logo.svg
        EOF

        mkdir -p hcout
        hyprcursor-util --create hc-src --output hcout
        mkdir -p $out/${hyprcursorThemeName}
        cp -r hcout/*/. $out/${hyprcursorThemeName}/

        mkdir -p pngs
        for sz in ${cursorSizesStr}; do
          resvg -w "$sz" -h "$sz" ${cursorLogoSvg} "pngs/logo-$sz.png"
        done

        cat > hyprland-logo.conf <<'EOF'
        ${xcursorgenConfLines}
        EOF

        xcursorgen hyprland-logo.conf left_ptr

        mkdir -p $out/${xcursorThemeName}/cursors
        cp left_ptr $out/${xcursorThemeName}/cursors/left_ptr
        ln -s left_ptr $out/${xcursorThemeName}/cursors/default
        ln -s left_ptr $out/${xcursorThemeName}/cursors/arrow

        cat > $out/${xcursorThemeName}/index.theme <<'EOF'
        [Icon Theme]
        Name=Hyprland Logo
        Comment=${cursorDescription}
        Inherits=Adwaita
        EOF
      '';
in
{
  theme = cursorTheme;
  inherit xcursorThemeName hyprcursorThemeName defaultCursorSize;
}
