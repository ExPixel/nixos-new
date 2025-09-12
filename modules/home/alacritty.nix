{ config, lib, pkgs, ... }:
let
    cfg = config.expixel.home.alacritty;
in {
    options.expixel.home.alacritty = {
        enable = lib.mkEnableOption "alacritty";
        theme  = lib.mkOption {
            type = lib.types.str;
            description = "Alacritty theme.";
            default = "gruvbox_dark";
        };
    };

    config = lib.mkIf cfg.enable {
        programs.alacritty.enable = true;
        programs.alacritty.theme = cfg.theme;
    };
}
