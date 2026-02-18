{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.grimblast ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings =
      let
        resizeFloating = pkgs.writeShellScript "resize-floating" ''
          info=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq '.[0]')
          w=$(echo $info | ${pkgs.jq}/bin/jq '.width')
          h=$(echo $info | ${pkgs.jq}/bin/jq '.height')
          rt=$(echo $info | ${pkgs.jq}/bin/jq '.reserved[1]')
          tw=$((w * 95 / 100 - 40))
          th=$((h - rt - 40))
          hyprctl dispatch resizeactive exact $tw $th
          hyprctl dispatch moveactive exact 20 $((rt + 20))
        '';
        launchWezterm = pkgs.writeShellScript "launch-wezterm" ''
          wezterm &
          ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
            case $line in
              openwindow*wezfurlong.wezterm*)
                hyprctl dispatch focuswindow class:org.wezfurlong.wezterm
                ${resizeFloating}
                exit 0
                ;;
            esac
          done
        '';
        swapFloatingTiled = pkgs.writeShellScript "swap-floating-tiled" ''
          is_floating=$(hyprctl activewindow -j | ${pkgs.jq}/bin/jq '.floating')
          if [ "$is_floating" = "true" ]; then
            hyprctl dispatch settiled
            hyprctl dispatch cyclenext
            hyprctl dispatch setfloating
            ${resizeFloating}
          else
            hyprctl dispatch setfloating
            ${resizeFloating}
            hyprctl dispatch cyclenext
            hyprctl dispatch settiled
          fi
        '';
      in
      {
        # Monitor configuration
        monitor = [
          "DP-1,preferred,0x0,1" # External monitor (top, at origin)
          "eDP-1,preferred,auto-center-down,1" # Laptop (centered below)
        ];

        # Environment variables
        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "GTK_IM_MODULE,fcitx"
          "QT_IM_MODULE,fcitx"
          "XMODIFIERS,@im=fcitx"
          "SDL_IM_MODULE,fcitx"
          "GLFW_IM_MODULE,ibus"
          "INPUT_METHOD,fcitx5"
          "IMSETTINGS_MODULE,fcitx5"
        ];

        # Programs
        "$menu" = "wofi --show drun";
        "$mainMod" = "SUPER";

        # Autostart programs
        exec-once = [
          "fcitx5 -d"
          "waybar"
          "google-chrome-stable"
          "${launchWezterm}"
        ];

        # General settings
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        # Decoration settings
        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = false;
          };
        };

        # Animation settings
        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        # Layout settings
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        # Misc settings
        misc = {
          force_default_wallpaper = 1;
          disable_hyprland_logo = false;
        };

        # Input settings
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;

          touchpad = {
            natural_scroll = true;
            scroll_factor = 0.3;
          };
        };

        # Device-specific config
        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        # Key bindings
        bind = [
          # Basic binds
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, F, exec, hyprctl dispatch setfloating && ${resizeFloating}"
          "$mainMod, T, settiled,"
          "$mainMod, R, exec, $menu"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"

          # Application shortcuts
          "$mainMod, W, exec, ${launchWezterm}"
          "$mainMod, B, exec, google-chrome-stable"
          "$mainMod, S, exec, slack"
          "$mainMod, D, exec, discord"

          # Move focus with arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Swap floating and tiled window states
          "$mainMod, Tab, exec, ${swapFloatingTiled}"

          # Switch workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to workspace
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Special workspace
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through workspaces
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Input method toggle
          "CTRL, space, exec, fcitx5-remote -t"

          # Screenshot (PrintScreen key is recognized as F9)
          ", F9, exec, grimblast copysave screen"
        ];

        # Repeat binds for volume and brightness
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, light -A 5"
          ",XF86MonBrightnessDown, exec, light -U 5"
        ];

        # Locked binds for media control
        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        # Mouse binds for moving/resizing windows
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # Window rules
        windowrule = [
          "suppress_event maximize, match:class .*"
          "no_focus on, match:class ^$ match:title ^$ match:xwayland true match:float true match:fullscreen false match:pin false"
          "float on, match:class ^(org.wezfurlong.wezterm)$"
        ];
      };
  };
}
