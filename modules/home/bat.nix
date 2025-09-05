{ config, lib, pkgs, ... }:
let
    cfg = config.expixel.home.bat;
in {
    options.expixel.home.bat = {
        enable = lib.mkEnableOption "bat";
        theme = lib.mkOption {
            type = lib.types.enum [ "" ];
        };
    };

    config = lib.mkIf cfg.enable {
        programs.bat.enable = true;
    };
}
