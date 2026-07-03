_: {
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
          "pulseaudio"
          "clock"
          "network"
          "bluetooth"
          "battery"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        clock = {
          format = " {:%H:%M}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            headphone = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };

        battery = {
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          format-wifi = "";
          format-disconnected = "󰤮";
          tooltip-format = "{essid} ({ipaddr})";
          on-click = "wezterm start -- wifitui";
        };

        bluetooth = {
          format = "";
          format-disabled = "󰂲";
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
      #pulseaudio:hover,
      #network:hover,
      #bluetooth:hover,
      #battery:hover {
        opacity: 0.8;
      }

      /* Workspaces — blue, active pink, urgent red */
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

      /* Clock — mauve */
      #clock {
        color: #cba6f7;
        border: 1px solid #cba6f7;
      }

      /* Pulseaudio — green, muted greyed out */
      #pulseaudio {
        color: #a6e3a1;
        border: 1px solid #a6e3a1;
      }

      #pulseaudio.muted {
        color: #6c7086;
        border-color: #6c7086;
        text-decoration: line-through;
      }

      /* Network — sky */
      #network {
        color: #89dceb;
        border: 1px solid #89dceb;
      }

      /* Bluetooth — lavender */
      #bluetooth {
        color: #b4befe;
        border: 1px solid #b4befe;
      }

      /* Battery — peach, with charging/warning/critical accents */
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
