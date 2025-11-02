{ config, pkgs, ... }:
{
    imports = [
        ../../modules/home/neovim.nix
        ../../modules/home/tmux.nix
        ../../modules/home/bat.nix
    ];

    ### XDG
    xdg.userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
            XDG_CODE_DIR = "${config.home.homeDirectory}/code";
        };

        # directories
        desktop = null;
        documents = null;
        download = "${config.home.homeDirectory}/download";
        music = null;
        pictures = null;
        publicShare = null;
        templates = null;
        videos = null;
    };

    ### Git / Start
    programs.git.enable = true;
    programs.git.aliases = {
        ocmmit = "commit";
    };
    programs.git.settings = {
        init.defaultBranch = "main";
        user.name = "Marc C.";
        user.email = "adolphc@outlook.com";
    };

    ### Fish
    programs.fish.enable = true;
    programs.fish.interactiveShellInit = ''
        set fish_greeting # disable greeting
    '';
    programs.fish.shellInit = ''
    fish_add_path -g "$HOME/.cargo/bin"
    '';
    programs.fish.shellAliases = {
        "%" = "fg %1";
        "%1" = "fg %1";
        "%2" = "fg %2";
        "%3" = "fg %3";
        "%4" = "fg %4";
        winip = "ip route show | grep -i default | awk '{ print $3}'";
    };
    programs.fish.functions = {
        esp_source = ''
        # for https://docs.esp-rs.org/book/installation/riscv-and-xtensa.html#3-set-up-the-environment-variables
        if test -f $HOME/export-esp.sh
            source $HOME/export-esp.sh
        else
            echo 'export-esp.sh not found, did you install espup and run `espup install`?'
        end
        '';

        usbconnect = ''
        set -l busid $argv[1]
        echo "connecting busid $busid"

        set -l raw_bus_state (usbipd.exe list | awk -v id="$busid" '$1 == id {print $NF}')
        set -l bus_state (string trim $raw_bus_state)
        if test -z "$bus_state"
            echo "Device not found, try running `sudo.exe usbipd bind --busid $busid` in Windows."
            return 1
        end

        echo "current usb bus state: [$bus_state]"
        if test "$bus_state" != "Attached" -a "$bus_state" != "Shared"
            echo "busid $busid is not shared or attached, sharing..."
            sudo.exe usbipd attach --wsl --busid=$busid
        else
            echo "busid $busid is already shared/attached"
        end

        if not lsmod | grep -q '^vhci_hcd'
            echo "vhci_hcd not loaded, loading now..."
            sudo modprobe vhci_hcd
        end

        sudo usbip attach --remote=$(winip) --busid=$busid
        '';

        code = ''
        set -l code_cmd (command -a code)[1]
        $code_cmd $argv
        '';
    };

    ### Bash
    programs.bash.enable = true;
    programs.bash.shellAliases = {
        tt = "tmux new-session -A -s main";
        winip = "ip route show | grep -i default | awk '{ print $3}'";
    };

    ### direnv
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.direnv.enableBashIntegration = true;

    ### Starship
    programs.starship.enable = true;
    programs.starship.enableFishIntegration = true;
    programs.starship.enableBashIntegration = true;

    ### tmux
    expixel.home.tmux.enable = true;

    ### Neovim (nvim)
    expixel.home.neovim.enable = true;

    ### Bat
    expixel.home.bat.enable = true;

    ### IdeaVim configuration (for PHPStorm and other JetBrains IDEs)
    home.file.".ideavimrc".text = ''
        set visualbell
        set noerrorbells
        set incsearch
        set ignorecase
        set smartcase
    '';

    ### END
    home.stateVersion = "24.11";
}
