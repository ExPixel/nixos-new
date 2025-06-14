{ config, pkgs, ... }:
{
    imports = [];

    ### System Packages
    environment.systemPackages = [
        pkgs.killall
        pkgs.zip
        pkgs.unzip
        pkgs.tldr
        pkgs.neovim
        pkgs.rustup
        pkgs.clang_19
        pkgs.wget
        pkgs.curl
        pkgs.htop
        pkgs.btop
        pkgs.jq
        pkgs.gh
        pkgs.u-root-cmds
    ];

    ### User Management
    users.users.marc = {
        isNormalUser = true;
        home = "/home/marc";
        description = "Marc";
        extraGroups = [ "wheel" "networkmanager" "docker" ];
    };

    ### Networking
    networking.hostName = "nixwsl";
    networking.networkmanager.enable = true;
    programs.ssh.startAgent = true;
    services.tailscale.enable = true;

    ### MySQL
    services.mysql.enable = true;
    services.mysql.package = pkgs.mariadb;

    ### Docker
    virtualisation.docker.enable = true;

    ### nix-ld
    # This allows VS Code remote to run.
    programs.nix-ld.enable = true;


    ### Locale
    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };
}
