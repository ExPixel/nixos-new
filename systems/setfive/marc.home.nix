{ config, pkgs, ... }:
{
    imports = [
        ../../modules/home/neovim.nix
        ../../modules/home/tmux.nix
        ../../modules/home/alacritty.nix
    ];

    ### Firefox
    programs.firefox.enable = true;

    ### XDG
    xdg.userDirs.enable = true;
    xdg.userDirs.createDirectories = true;
    xdg.userDirs.extraConfig = {
        XDG_CODE_DIR = "${config.home.homeDirectory}/Code";
    };

    ### Git / Start
    programs.git.enable = true;
    programs.git.userName = "Marc C.";
    programs.git.userEmail = "marc@setfive.com";
    programs.git.extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
    };

    ### Fish
    programs.fish.enable = true;
    programs.fish.interactiveShellInit = ''
        set fish_greeting # disable greeting
    '';
    programs.fish.shellAliases = {
        "%" = "fg %1";
        "%1" = "fg %1";
        "%2" = "fg %2";
        "%3" = "fg %3";
        "%4" = "fg %4";
    };

    ### Alacritty
    expixel.home.alacritty.enable = true;

    ### Bash
    programs.bash.enable = true;
    programs.bash.shellAliases = {
        tt = "tmux new-session -A -s main";
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

    ### VS Code
    programs.vscode.enable = true;

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
