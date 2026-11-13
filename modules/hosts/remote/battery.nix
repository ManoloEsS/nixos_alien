{ pkgs, ... }:

let
  restoreThresholds = pkgs.writeShellScript "e14-restore-charge-thresholds" ''
    set -eu

    status=/var/lib/upower/charging-threshold-status
    battery=/sys/class/power_supply/BAT0

    # An absent or disabled UPower setting must not enable charging limits.
    [ -r "$status" ] || exit 0
    [ "$(< "$status")" = 1 ] || exit 0
    [ -w "$battery/charge_control_start_threshold" ] || exit 0
    [ -w "$battery/charge_control_end_threshold" ] || exit 0

    if [ "$(< "$battery/charge_control_start_threshold")" != 75 ]; then
      echo 75 > "$battery/charge_control_start_threshold"
    fi
    if [ "$(< "$battery/charge_control_end_threshold")" != 80 ]; then
      echo 80 > "$battery/charge_control_end_threshold"
    fi

    # Refresh UPower's properties after the firmware values are restored.
    ${pkgs.systemd}/bin/systemctl try-restart upower.service
  '';
in
{
  # This rule is imported only by the E14 profile, not the Alien host.
  services.udev.extraHwdb = ''
    battery:*:*:dmi:*
     CHARGE_LIMIT=75,80
  '';

  systemd.services.e14-restore-charge-thresholds = {
    description = "Restore ThinkPad E14 UPower charge thresholds";
    after = [ "upower.service" "systemd-udevd.service" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = "/sys/class/power_supply/BAT0/charge_control_end_threshold";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = restoreThresholds;
    };
  };
}
