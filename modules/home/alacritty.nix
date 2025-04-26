{ config, lib, pkgs, ... }:
let
    cfg = config.expixel.home.alacritty;
in {
    options.expixel.home.alacritty = {
        enable = lib.mkEnableOption "alacritty";
    };

    config = lib.mkIf cfg.enable {
        programs.alacritty.enable = true;
        programs.alacritty.theme = "gruvbox_dark";
    };
}
