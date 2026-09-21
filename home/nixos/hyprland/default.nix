{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;

  resizeFloating = pkgs.writeShellScript "resize-floating" ''
    hyprctl dispatch 'hl.dsp.window.float({ action = "enable" })'
    info=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq '.[0]')
    w=$(echo $info | ${pkgs.jq}/bin/jq '.width')
    h=$(echo $info | ${pkgs.jq}/bin/jq '.height')
    rt=$(echo $info | ${pkgs.jq}/bin/jq '.reserved[1]')
    tw=$((w * 95 / 100 - 40))
    th=$((h - rt - 40))
    hyprctl dispatch "hl.dsp.window.resize({ x = $tw, y = $th })"
    hyprctl dispatch "hl.dsp.window.move({ x = 20, y = $((rt + 20)) })"
  '';
  launchWezterm = pkgs.writeShellScript "launch-wezterm" ''
    wezterm &
  '';
  swapFloatingTiled = pkgs.writeShellScript "swap-floating-tiled" ''
    is_floating=$(hyprctl activewindow -j | ${pkgs.jq}/bin/jq '.floating')
    if [ "$is_floating" = "true" ]; then
      hyprctl dispatch 'hl.dsp.window.float({ action = "disable" })'
      hyprctl dispatch 'hl.dsp.window.cycle_next()'
      ${resizeFloating}
    else
      ${resizeFloating}
      hyprctl dispatch 'hl.dsp.window.cycle_next()'
      hyprctl dispatch 'hl.dsp.window.float({ action = "disable" })'
    fi
  '';

  # NOTE: not using home.pointerCursor here because HYPRCURSOR_THEME/XCURSOR_THEME
  # must go through hl.env (see ENVIRONMENT VARIABLES below) for the same startup-
  # timing reason as the other hl.env-only vars (GTK_IM_MODULE, etc.) in this file.
  cursor = import ./cursor { inherit pkgs; };

  mainMod = "SUPER";
  menu = "wofi --show drun";

  mkEnv = name: value: {
    _args = [
      name
      value
    ];
  };
  mkCurve = name: points: {
    _args = [
      name
      {
        type = "bezier";
        inherit points;
      }
    ];
  };
  mkBind = key: dsp: {
    _args = [
      key
      (mkLuaInline dsp)
    ];
  };
  mkBindOpts = key: dsp: opts: { _args = (mkBind key dsp)._args ++ [ opts ]; };

  # Switch workspaces with mainMod + [0-9], move active window with mainMod + SHIFT + [0-9].
  wsBinds = lib.concatMap (
    i:
    let
      key = toString (lib.mod i 10);
      ws = toString i;
    in
    [
      (mkBind "${mainMod} + ${key}" "hl.dsp.focus({ workspace = ${ws} })")
      (mkBind "${mainMod} + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${ws} })")
    ]
  ) (lib.range 1 10);
in
{
  home = {
    packages = [ pkgs.grimblast ];

    # XCursor theme (GTK/QT/XWayland apps like Chrome) and hyprcursor theme
    # (native Wayland, scales cleanly across mixed-DPI monitors).
    file.".icons/${cursor.xcursorThemeName}".source = "${cursor.theme}/${cursor.xcursorThemeName}";
    file.".local/share/icons/${cursor.hyprcursorThemeName}".source =
      "${cursor.theme}/${cursor.hyprcursorThemeName}";
  };

  wayland.windowManager.hyprland = {
    configType = "lua";
    enable = true;
    systemd.enable = true;

    # settings.<name> groups are otherwise rendered alphabetically; pin them to
    # the declaration order below.
    importantPrefixes = [
      "monitor"
      "env"
      "config"
      "device"
      "curve"
    ];

    # systemd.enable makes home-manager register its own hyprland.start hook
    # (dbus activation env + hyprland-session.target) after settings.* but
    # before extraConfig. Keep our autostart hook here, not in settings.on, so
    # it keeps firing after that hook instead of before it.
    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")
        hl.exec_cmd("${launchWezterm}")
      end)
    '';

    settings = {
      monitor = [
        {
          output = "DP-1";
          mode = "3840x2160@60";
          position = "0x0";
          scale = "1.25";
        }
        {
          output = "eDP-1";
          mode = "preferred";
          position = "auto-center-down";
          scale = "1";
        }
      ];

      env = [
        (mkEnv "XCURSOR_THEME" cursor.xcursorThemeName)
        (mkEnv "XCURSOR_SIZE" (toString cursor.defaultCursorSize))
        (mkEnv "HYPRCURSOR_THEME" cursor.hyprcursorThemeName)
        (mkEnv "HYPRCURSOR_SIZE" (toString cursor.defaultCursorSize))
        (mkEnv "GTK_IM_MODULE" "fcitx")
        (mkEnv "QT_IM_MODULE" "fcitx")
        (mkEnv "XMODIFIERS" "@im=fcitx")
        (mkEnv "SDL_IM_MODULE" "fcitx")
        (mkEnv "GLFW_IM_MODULE" "fcitx")
        (mkEnv "INPUT_METHOD" "fcitx5")
        (mkEnv "IMSETTINGS_MODULE" "fcitx5")
      ];

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          col = {
            active_border = {
              colors = [
                "rgba(33ccffee)"
                "rgba(00ff99ee)"
              ];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = mkLuaInline "0xee1a1a1a";
          };

          blur = {
            enabled = false;
          };
        };

        animations = {
          enabled = true;
        };

        dwindle = {
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          force_default_wallpaper = 1;
          disable_hyprland_logo = false;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;

          touchpad = {
            natural_scroll = true;
            scroll_factor = 0.3;
          };
        };

        cursor = {
          enable_hyprcursor = true;
        };
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      curve = [
        (mkCurve "easeOutQuint" [
          [
            0.23
            1
          ]
          [
            0.32
            1
          ]
        ])
        (mkCurve "easeInOutCubic" [
          [
            0.65
            0.05
          ]
          [
            0.36
            1
          ]
        ])
        (mkCurve "linear" [
          [
            0
            0
          ]
          [
            1
            1
          ]
        ])
        (mkCurve "almostLinear" [
          [
            0.5
            0.5
          ]
          [
            0.75
            1
          ]
        ])
        (mkCurve "quick" [
          [
            0.15
            0
          ]
          [
            0.1
            1
          ]
        ])
      ];

      animation = [
        {
          leaf = "global";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 5.39;
          bezier = "easeOutQuint";
        }
        {
          leaf = "windows";
          enabled = true;
          speed = 4.79;
          bezier = "easeOutQuint";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 4.1;
          bezier = "easeOutQuint";
          style = "popin 87%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 1.49;
          bezier = "linear";
          style = "popin 87%";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 1.73;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeOut";
          enabled = true;
          speed = 1.46;
          bezier = "almostLinear";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3.03;
          bezier = "quick";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 3.81;
          bezier = "easeOutQuint";
        }
        {
          leaf = "layersIn";
          enabled = true;
          speed = 4;
          bezier = "easeOutQuint";
          style = "fade";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 1.5;
          bezier = "linear";
          style = "fade";
        }
        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 1.79;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 1.39;
          bezier = "almostLinear";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 1.94;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "workspacesIn";
          enabled = true;
          speed = 1.21;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "workspacesOut";
          enabled = true;
          speed = 1.94;
          bezier = "almostLinear";
          style = "fade";
        }
      ];

      bind = [
        # Basic binds
        (mkBind "${mainMod} + C" "hl.dsp.window.close()")
        (mkBind "${mainMod} + M" "hl.dsp.exit()")
        (mkBind "${mainMod} + F" ''hl.dsp.exec_cmd("${resizeFloating}")'')
        (mkBind "${mainMod} + T" ''hl.dsp.window.float({ action = "disable" })'')
        (mkBind "${mainMod} + R" ''hl.dsp.exec_cmd("${menu}")'')
        (mkBind "${mainMod} + P" "hl.dsp.window.pseudo()")
        (mkBind "${mainMod} + J" ''hl.dsp.layout("togglesplit")'')

        # Application shortcuts
        (mkBind "${mainMod} + W" ''hl.dsp.exec_cmd("${launchWezterm}")'')
        (mkBind "${mainMod} + B" ''hl.dsp.exec_cmd("google-chrome-stable")'')
        (mkBind "${mainMod} + D" ''hl.dsp.exec_cmd("discord")'')

        # Move focus with arrow keys
        (mkBind "${mainMod} + left" ''hl.dsp.focus({ direction = "left" })'')
        (mkBind "${mainMod} + right" ''hl.dsp.focus({ direction = "right" })'')
        (mkBind "${mainMod} + up" ''hl.dsp.focus({ direction = "up" })'')
        (mkBind "${mainMod} + down" ''hl.dsp.focus({ direction = "down" })'')

        # Swap window position
        (mkBind "${mainMod} + SHIFT + left" ''hl.dsp.window.swap({ direction = "left" })'')
        (mkBind "${mainMod} + SHIFT + right" ''hl.dsp.window.swap({ direction = "right" })'')
        (mkBind "${mainMod} + SHIFT + up" ''hl.dsp.window.swap({ direction = "up" })'')
        (mkBind "${mainMod} + SHIFT + down" ''hl.dsp.window.swap({ direction = "down" })'')

        # Swap floating and tiled window states
        (mkBind "${mainMod} + Tab" ''hl.dsp.exec_cmd("${swapFloatingTiled}")'')
      ]
      ++ wsBinds
      ++ [
        # Special workspace (scratchpad)
        (mkBind "${mainMod} + S" ''hl.dsp.workspace.toggle_special("magic")'')
        (mkBind "${mainMod} + SHIFT + S" ''hl.dsp.window.move({ workspace = "special:magic" })'')

        # Scroll through workspaces
        (mkBind "${mainMod} + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
        (mkBind "${mainMod} + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

        # Screenshot
        (mkBind "F9" ''hl.dsp.exec_cmd("grimblast copysave screen")'')

        # Repeat binds for window resize
        (mkBindOpts "${mainMod} + CTRL + right" "hl.dsp.window.resize({ x = 50, y = 0, relative = true })" {
          repeating = true;
        })
        (mkBindOpts "${mainMod} + CTRL + left" "hl.dsp.window.resize({ x = -50, y = 0, relative = true })" {
          repeating = true;
        })
        (mkBindOpts "${mainMod} + CTRL + up" "hl.dsp.window.resize({ x = 0, y = -50, relative = true })" {
          repeating = true;
        })
        (mkBindOpts "${mainMod} + CTRL + down" "hl.dsp.window.resize({ x = 0, y = 50, relative = true })" {
          repeating = true;
        })

        # Volume and brightness
        (mkBindOpts "XF86AudioRaiseVolume"
          ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")''
          {
            locked = true;
            repeating = true;
          }
        )
        (mkBindOpts "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")''
          {
            locked = true;
            repeating = true;
          }
        )
        (mkBindOpts "XF86AudioMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'' {
          locked = true;
          repeating = true;
        })
        (mkBindOpts "XF86AudioMicMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'' {
          locked = true;
          repeating = true;
        })
        (mkBindOpts "XF86MonBrightnessUp" ''hl.dsp.exec_cmd("brightnessctl set 5%+")'' {
          locked = true;
          repeating = true;
        })
        (mkBindOpts "XF86MonBrightnessDown" ''hl.dsp.exec_cmd("brightnessctl set 5%-")'' {
          locked = true;
          repeating = true;
        })

        # Media control
        (mkBindOpts "XF86AudioNext" ''hl.dsp.exec_cmd("playerctl next")'' { locked = true; })
        (mkBindOpts "XF86AudioPause" ''hl.dsp.exec_cmd("playerctl play-pause")'' { locked = true; })
        (mkBindOpts "XF86AudioPlay" ''hl.dsp.exec_cmd("playerctl play-pause")'' { locked = true; })
        (mkBindOpts "XF86AudioPrev" ''hl.dsp.exec_cmd("playerctl previous")'' { locked = true; })

        # Mouse binds for moving/resizing windows
        (mkBindOpts "${mainMod} + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
        (mkBindOpts "${mainMod} + mouse:273" "hl.dsp.window.resize()" { mouse = true; })
      ];

      window_rule = [
        {
          name = "suppress-maximize-events";
          match = {
            class = ".*";
          };
          suppress_event = "maximize";
        }
        {
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }
      ];
    };
  };
}
