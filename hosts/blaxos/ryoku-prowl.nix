# Ryoku Rashin starts Prowl with `systemctl --user start ryoku-prowl.service`,
# but the Ryoku-on-NixOS module does not define that unit yet, so Prowl fails
# with "Unit ryoku-prowl.service not found". This mirrors upstream's
# ryoku/rashin/systemd/ryoku-prowl.service.
#
# Every value is mkDefault: once the Ryoku module ships the unit itself, its
# definitions win and this file becomes a no-op that can be deleted.
{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  ryokuBundle =
    inputs.ryoku.packages.${pkgs.stdenv.hostPlatform.system}.ryoku-upstream-nixos-bundle;
in
{
  systemd.user.services.ryoku-rashin.wants = lib.mkDefault [
    "ryoku-prowl.service"
  ];

  systemd.user.services.ryoku-prowl = {
    description = lib.mkDefault "Ryoku Prowl: model gateway and code intelligence for Rashin";

    bindsTo = lib.mkDefault [ "ryoku-rashin.service" ];
    after = lib.mkDefault [ "ryoku-rashin.service" ];

    unitConfig = {
      StartLimitIntervalSec = lib.mkDefault 0;
      ConditionUser = lib.mkDefault "!@system";
    };

    preStart = lib.mkDefault ''
      ${ryokuBundle}/bin/prowl gateway down --port "''${RYOKU_PROWL_PORT:-8788}" || true
    '';

    script = lib.mkDefault ''
      exec ${ryokuBundle}/bin/prowl gateway serve --port "''${RYOKU_PROWL_PORT:-8788}"
    '';

    serviceConfig = {
      Restart = lib.mkDefault "on-failure";
      RestartSec = lib.mkDefault 2;
      NoNewPrivileges = lib.mkDefault true;
    };
  };
}
