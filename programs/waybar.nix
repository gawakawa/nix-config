{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [ ];
        modules-center = [ ];
        modules-right = [
          "battery"
          "network"
          "clock"
        ];

        clock = {
          format = "{:%H:%M}";
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
          format-wifi = "{essid} ";
          format-ethernet = "{ifname} ";
          format-disconnected = "Disconnected ⚠";
          tooltip-format = "{ifname}: {ipaddr}";
        };
      };
    };

    style = ''
      * {
        font-family: "Noto Sans", "Font Awesome 6 Free";
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(43, 48, 59, 0.9);
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 10px;
        color: #ffffff;
      }

      #workspaces button.active {
        background-color: rgba(255, 255, 255, 0.2);
      }

      #clock, #battery, #network, #pulseaudio, #tray {
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
