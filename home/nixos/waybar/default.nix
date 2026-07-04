let
  # Icon glyphs, generated from numeric Nerd Font codepoints (never typed
  # directly) so their bytes can't be silently dropped/corrupted:
  #   - clock/battery/network/bluetooth icons: extracted byte-for-byte from
  #     the previously working config (git rev a9e568f).
  #   - pulseaudio icons: extracted byte-for-byte from a verified external
  #     Waybar config (Uliboooo/dotfiles .config/waybar/config.hypr.jsonc).
  #   - brightness icons: codepoints looked up in the installed
  #     NotoSansNerdFont-SemiBold.ttf cmap (nerd-fonts.noto), not typed from
  #     memory, then rendered via `chr()` and byte-verified with `od`.
  icons = {
    clock = ""; # U+F017 nf-fa-clock_o
    batteryLevels = [
      ""
      ""
      ""
      ""
      ""
    ]; # U+F244..U+F240 nf-fa-battery (empty..full)
    wifi = ""; # U+F1EB nf-fa-wifi
    wifiOff = "󰤮"; # U+F092E nf-md-wifi-off
    bluetooth = ""; # U+F294 nf-fa-bluetooth
    bluetoothOff = "󰂲"; # U+F00B2 nf-md-bluetooth-off
    volumeMuted = "󰝟"; # U+F075F nf-md-volume-off
    volumeLevels = [
      "󰕿"
      "󰖀"
      "󰕾"
    ]; # U+F057F/F0580/F057E nf-md-volume low/med/high
    brightnessLevels = [
      "󰃚"
      "󰃝"
      "󰃠"
    ]; # U+F00DA/F00DD/F00E0 nf-md-brightness_1/4/7 low/mid/high
  };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ ];
        modules-right = [
          "group/backlight"
          "group/pulseaudio"
          "clock"
          "network"
          "bluetooth"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        clock = {
          format = icons.clock + " {:%H:%M}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = icons.volumeMuted + " MUTED";
          format-icons = {
            default = icons.volumeLevels;
          };
          scroll-step = 5; # match the 5% step used by the Hyprland volume keybindings
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        "group/pulseaudio" = {
          orientation = "horizontal";
          drawer = {
            click-to-reveal = true;
          };
          modules = [
            "pulseaudio"
            "pulseaudio/slider"
          ];
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = icons.brightnessLevels;
          scroll-step = 5;
        };

        "backlight/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        "group/backlight" = {
          orientation = "horizontal";
          drawer = {
            click-to-reveal = true;
          };
          modules = [
            "backlight"
            "backlight/slider"
          ];
        };

        battery = {
          format = "{capacity}% {icon}";
          format-icons = icons.batteryLevels;
        };

        network = {
          format-wifi = icons.wifi;
          format-disconnected = icons.wifiOff;
          tooltip-format = "{essid} ({ipaddr})";
          on-click = "wezterm start -- wifitui";
        };

        bluetooth = {
          format = icons.bluetooth;
          format-disabled = icons.bluetoothOff;
          format-connected = " {num_connections}";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{device_enumerate}";
          on-click = "wezterm start -- bluetui";
        };
      };
    };

    # Catppuccin Mocha palette, HyprPanel-style colorful rounded module "chips":
    # each module is its own translucent pill with a distinct accent color
    # (background + border + text), so the bar reads as a set of colorful
    # rounded frames rather than one flat strip.
    style = ''
      * {
        font-family: "NotoSans Nerd Font";
        font-size: 14px;
        font-weight: 600;
      }

      window#waybar {
        background-color: transparent;
        color: #cdd6f4;
      }

      tooltip {
        background: rgba(24, 24, 37, 0.9);
        border: 1px solid #f5c2e7;
        border-radius: 8px;
      }

      tooltip label {
        color: #cdd6f4;
      }

      #workspaces,
      #clock,
      #backlight,
      #pulseaudio,
      #network,
      #bluetooth,
      #battery,
      #tray {
        background-color: rgba(30, 30, 46, 0.6);
        border-radius: 10px;
        padding: 0 12px;
        margin: 4px 3px;
        text-shadow: 0 0 2px rgba(0, 0, 0, 0.5);
        transition: opacity 0.2s ease-in-out;
      }

      #workspaces:hover,
      #clock:hover,
      #backlight:hover,
      #pulseaudio:hover,
      #network:hover,
      #bluetooth:hover,
      #battery:hover {
        opacity: 0.8;
      }

      /* Workspaces -- blue, active pink, urgent red */
      #workspaces {
        color: #89b4fa;
        border: 1px solid #89b4fa;
        padding: 0 8px;
      }

      #workspaces button {
        padding: 0 6px;
        color: #89b4fa;
      }

      #workspaces button.active {
        color: #f5c2e7;
      }

      #workspaces button.urgent {
        color: #f38ba8;
      }

      /* Clock -- mauve */
      #clock {
        color: #cba6f7;
        border: 1px solid #cba6f7;
      }

      /* Pulseaudio -- green, muted greyed out */
      #pulseaudio {
        color: #a6e3a1;
        border: 1px solid #a6e3a1;
      }

      #pulseaudio.muted {
        color: #6c7086;
        border-color: #6c7086;
        text-decoration: line-through;
      }

      /* Backlight -- yellow */
      #backlight {
        color: #f9e2af;
        border: 1px solid #f9e2af;
      }

      /* Volume/brightness sliders -- Mac-style thin rounded track */
      #pulseaudio-slider,
      #backlight-slider {
        padding: 0 8px;
        margin: 4px 3px;
        min-width: 90px;
      }

      #pulseaudio-slider trough,
      #backlight-slider trough {
        min-height: 6px;
        border-radius: 6px;
        background-color: rgba(108, 112, 134, 0.5);
      }

      #pulseaudio-slider highlight {
        border-radius: 6px;
        background-color: #a6e3a1;
      }

      #backlight-slider highlight {
        border-radius: 6px;
        background-color: #f9e2af;
      }

      #pulseaudio-slider slider,
      #backlight-slider slider {
        min-width: 12px;
        min-height: 12px;
        border-radius: 50%;
        background-color: #cdd6f4;
      }

      /* Network -- sky */
      #network {
        color: #89dceb;
        border: 1px solid #89dceb;
      }

      /* Bluetooth -- lavender */
      #bluetooth {
        color: #b4befe;
        border: 1px solid #b4befe;
      }

      /* Battery -- peach, with charging/warning/critical accents */
      #battery {
        color: #fab387;
        border: 1px solid #fab387;
      }

      #battery.charging {
        color: #a6e3a1;
        border-color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        color: #f9e2af;
        border-color: #f9e2af;
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
        border-color: #f38ba8;
      }

      #tray {
        padding: 0 8px;
      }

      #tray > * {
        margin: 0 6px;
      }
    '';
  };
}
