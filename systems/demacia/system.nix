{ config, pkgs, ... }:
{
    imports = [
        ./hardware.nix
    ];

    ### System Packages
    environment.systemPackages = [
        pkgs.killall
        pkgs.zip
        pkgs.unzip
        pkgs.tldr
        pkgs.neovim
        pkgs.wget
        pkgs.curl
        pkgs.htop
        pkgs.btop
        pkgs.jq
        pkgs.clang_19
        pkgs.glxinfo


        pkgs.gnomeExtensions.appindicator # systray icons
        pkgs.gnome-settings-daemon # ensure gnome-settings-daemon udev rules are enabled
        pkgs.gnome-tweaks # mostly to remap capslock to escape
    ];

    ### User Management
    users.users.marc = {
        isNormalUser = true;
        home = "/home/marc";
        description = "Marc";
        extraGroups = [ "wheel" "networkmanager" "docker" ];
    };

    ### Networking
    networking.hostName = "nixhome";
    networking.networkmanager.enable = true;
    programs.ssh.startAgent = true;
    services.tailscale.enable = true;
    services.printing.enable = true;
    # Enable autodiscovery of network printers
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    ### Docker
    virtualisation.docker.enable = true;

    ### nix-ld
    # This allows VS Code remote to run.
    programs.nix-ld.enable = true;

    ### Boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    ### Fonts
    fonts.packages = with pkgs; [ iosevka noto-fonts roboto roboto-mono roboto-serif ubuntu_font_family ];
    fonts.enableDefaultPackages = true;

    ### OpenGL
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages = with pkgs; [ mesa ];

    ### PipeWire
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    ### Gnome
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = with pkgs; [
        orca
        evince
        geary
        gnome-disk-utility
        gnome-backgrounds
        gnome-tour # GNOME Shell detects the .desktop file on first log-in.
        gnome-user-docs
        baobab
        epiphany
        gnome-text-editor
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        gnome-weather
        gnome-connections
        simple-scan
        snapshot
        totem
        yelp
        gnome-software
    ];

    ### NVIDIA
    hardware.nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = true;
        prime = {
            intelBusId = "PCI:00:02.0";
            nvidiaBusId = "PCI:01:00.0";
        };
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    ### Locale & Time
    time.hardwareClockInLocalTime = true;
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
