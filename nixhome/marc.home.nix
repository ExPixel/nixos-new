{ config, pkgs, ... }:
{
    imports = [];

    ### XDG
    xdg.userDirs.enable = true;
    xdg.userDirs.createDirectories = true;
    xdg.userDirs.extraConfig = {
        XDG_CODE_DIR = "${config.home.homeDirectory}/Code";
    };

    ### Git / Start
    programs.git.enable = true;
    programs.git.userName = "Marc C.";
    programs.git.userEmail = "adolphc@outlook.com";
    programs.git.extraConfig = {
        init.defaultBranch = "main";
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
    programs.tmux.enable = true;
    programs.tmux.shell = "${config.home.profileDirectory}/bin/fish";
    programs.tmux.plugins = [
        {
            plugin = pkgs.tmuxPlugins.gruvbox;
            extraConfig = ''
                set -g @tmux-gruvbox 'dark'
            '';
        }
        pkgs.tmuxPlugins.sensible
    ];
    programs.tmux.extraConfig = ''
        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix

        set   -g  mouse on
        set   -g  history-limit 5000
        set   -g  base-index 1
        setw  -g  pane-base-index 1
        set   -g  renumber-windows on
        set   -g  default-terminal "tmux-256color"
        set   -gs escape-time 10
        set-option -sa terminal-features ',xterm-256color:RGB'

        ### keybindings
        bind-key r    source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux configuration"
        bind-key \`   switch-client -t'{marked}'
        bind-key "|"  split-window -h -c "#{pane_current_path}"
        bind-key "\\"   split-window -fh -c "#{pane_current_path}"
        bind-key "-"  split-window -v -c "#{pane_current_path}"
        bind-key "_"  split-window -fv -c "#{pane_current_path}"
        bind-key c    new-window -c "#{pane_current_path}"
        bind-key Space  last-window
        bind-key z    resize-pane -Z

        bind-key h select-pane -L; bind-key C-h select-pane -L
        bind-key j select-pane -D; bind-key C-j select-pane -D
        bind-key k select-pane -U; bind-key C-k select-pane -U
        bind-key l select-pane -R; bind-key C-l select-pane -R

        bind-key -r C-S-J resize-pane -D 15
        bind-key -r C-S-K resize-pane -U 15
        bind-key -r C-S-H resize-pane -L 15
        bind-key -r C-S-L resize-pane -R 15

        bind-key -n C-S-Left  swap-window -t -1\; select-window -t -1
        bind-key -n C-S-Right swap-window -t +1\; select-window -t +1

        bind -T root F12  set prefix None \; set key-table off \; if -F '#{pane_in_mode}' 'send-keys -X cancel' \; refresh-client -S \;
        bind -T off F12 set -u prefix \; set -u key-table \; refresh-client -S

        ### keybindigs-copy-mode
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi V send -X select-line
        bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
    '';

    ### Neovim (nvim)
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;
    programs.neovim.viAlias = true;
    programs.neovim.vimAlias = true;
    programs.neovim.extraLuaConfig = ''
        -- disable netrw (garbage)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- line numbers
        vim.opt.number = true
        vim.opt.relativenumber = true

        -- indentation options
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true
        vim.smartindent = true

        -- cache directories
        vim.opt.swapfile = false
        vim.opt.backup = false
        vim.opt.undodir = vim.fn.stdpath('data') .. '/vim/undodir'
        vim.opt.undofile = true

        -- search options
        vim.opt.hlsearch = false
        vim.opt.incsearch = true
        vim.opt.ignorecase = true
        vim.opt.smartcase = true

        -- misc options
        vim.opt.wrap = false
        vim.opt.scrolloff = 8
        vim.opt.signcolumn = 'yes'
        vim.opt.isfname:append("@-@")
        vim.opt.updatetime = 50
        vim.opt.colorcolumn = '120'
        vim.g.mapleader = ','
        vim.opt.termguicolors = true
        vim.opt.noerrorbells = true

        -- key bindings
        vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
        vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
        vim.keymap.set("n", "J", "mzJ`z")
        vim.keymap.set("n", "<C-d>", "<C-d>zz")
        vim.keymap.set("n", "<C-u>", "<C-u>zz")
        vim.keymap.set("x", "<leader>p", [["_dP]])
        vim.keymap.set('i', '<C-c>', '<Esc>')
        vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
        vim.keymap.set("n", "<leader>Y", [["+Y]])
        vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
        vim.keymap.set('n', 'Q', '<nop>')
        vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
        vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
        vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
        vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
        vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
        vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>")
        vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>")

        -- tree sitter parser dir must be part of the runtime path or else it will try to reinstall
        -- the parsers every time I open neovim.
        vim.opt.runtimepath:prepend(vim.fn.stdpath('data') .. '/nvim-treesitter')

        -- This separator is necessary to remove ambiguity from LUA syntax so that
        -- the following immediately invoked functions aren't considered function calls.
        ;
    '';
    programs.neovim.plugins = [
    pkgs.vimPlugins.lualine-nvim
    {
        plugin = pkgs.vimPlugins.nvim-treesitter;
        type = "lua";
        config = ''
        (function()
            require("nvim-treesitter.configs").setup({
                -- A list of parser names, or "all"
                ensure_installed = { "javascript", "typescript", "c", "lua", "rust" },
        
                 -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,
        
                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = false,

                parser_install_dir = vim.fn.stdpath('data') .. '/nvim-treesitter',
        
                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,
            
            
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            })
        end)();
        '';
    }
    {
        plugin = pkgs.vimPlugins.telescope-nvim;
        type = "lua";
        config = ''
        (function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>fs', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") });
            end)
        end)();
        '';
    }
    {
        plugin = pkgs.vimPlugins.nvim-tree-lua;
        type = "lua";
        config = ''
        (function()
            require("nvim-tree").setup({
                sort_by = "case_sensitive",
            })
        
            vim.keymap.set('n', '<leader>fe', function()
                vim.cmd("NvimTreeToggle")
            end)
        end)();
        '';
    }
    {
        plugin = pkgs.vimPlugins.gruvbox-nvim;
        type = "lua";
        config = ''
        vim.o.background = "dark";
        vim.cmd([[colorscheme gruvbox]]);
        '';
    }
    pkgs.vimPlugins.vim-fugitive
    pkgs.vimPlugins.vim-commentary
    ];

    ### END

    home.stateVersion = "24.11";
}
