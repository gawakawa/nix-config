_: {
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [ ];
        modules-center = [ ];
        modules-right = [
          "clock"
          "network"
          "bluetooth"
          "battery"
        ];

        clock = {
          format = " {:%H:%M}";
        };

        battery = {
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          format-wifi = "";
          format-disconnected = "󰤮";
          tooltip-format = "{essid} ({ipaddr})";
          on-click = "wezterm start -- wifitui";
        };

        bluetooth = {
          format = "";
          format-disabled = "󰂲";
          format-connected = " {num_connections}";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{device_enumerate}";
          on-click = "DMENU_BLUETOOTH_LAUNCHER='wofi --dmenu' dmenu-bluetooth";
        };
      };
    };

    style = ''
      * {
        font-family: "NotoSans Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background-color: transparent;
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 10px;
        color: #ffffff;
      }

      #workspaces button.active {
        background-color: rgba(255, 255, 255, 0.2);
      }

      #clock, #battery, #network, #bluetooth, #pulseaudio, #tray {
        padding: 0 10px;
      }

      #battery.charging {
        color: #26A65B;
      }

      #battery.warning:not(.charging) {
        color: #ffbe61;
      }

      #battery.critical:not(.charging) {
        color: #f53c3c;
      }
    '';
  };
}
