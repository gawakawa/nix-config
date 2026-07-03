{ pkgs, ... }:
let
  bluetoothWofi = pkgs.writeShellApplication {
    name = "bluetooth-wofi";
    runtimeInputs = [
      pkgs.bluez
      pkgs.wofi
    ];
    text = ''
      # Lists paired Bluetooth devices in a wofi menu; lets you toggle adapter
      # power, trigger a scan, or connect/disconnect the selected device.

      power_status=$(bluetoothctl show | grep -oP 'Powered: \K(yes|no)' || true)
      : "''${power_status:=no}"

      if [ "$power_status" = "yes" ]; then
        power_label=" Power: On (click to turn off)"
      else
        power_label=" Power: Off (click to turn on)"
      fi

      scan_label=" Scan for devices (8s)"

      devices=""
      while read -r _ mac name; do
        connected=$(bluetoothctl info "$mac" | grep -oP 'Connected: \K(yes|no)' || true)
        if [ "$connected" = "yes" ]; then
          devices="$devices$name ($mac) - connected"$'\n'
        else
          devices="$devices$name ($mac)"$'\n'
        fi
      done < <(bluetoothctl devices)

      menu="$power_label"$'\n'"$scan_label"$'\n'"$devices"

      choice=$(printf '%s' "$menu" | wofi --dmenu --prompt "Bluetooth")

      if [ -z "$choice" ]; then
        exit 0
      fi

      case "$choice" in
        "$power_label")
          if [ "$power_status" = "yes" ]; then
            bluetoothctl power off
          else
            bluetoothctl power on
          fi
          ;;
        "$scan_label")
          bluetoothctl --timeout 8 scan on
          ;;
        *)
          mac=$(printf '%s' "$choice" | grep -oP '\(\K[0-9A-Fa-f:]+(?=\))' || true)
          if [ -z "$mac" ]; then
            exit 0
          fi
          if printf '%s' "$choice" | grep -q "connected"; then
            bluetoothctl disconnect "$mac"
          else
            bluetoothctl trust "$mac" || true
            bluetoothctl pair "$mac" || true
            bluetoothctl connect "$mac"
          fi
          ;;
      esac
    '';
  };
in
{
  home.packages = [ bluetoothWofi ];
}
