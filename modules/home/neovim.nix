{ config, lib, pkgs, ... }:
let
    cfg = config.expixel.home.neovim;
in {
    options.expixel.home.neovim = {
        enable = lib.mkEnableOption "Neovim";
    };

    config = lib.mkIf cfg.enable {
        programs.neovim.enable = true;
        programs.neovim.defaultEditor = true;
        programs.neovim.viAlias = true;
        programs.neovim.vimAlias = true;
        programs.neovim.initLua = ''
            vim.opt.number              = true  -- line numbers
            vim.opt.relativenumber      = true
            vim.opt.tabstop             = 4     -- indentation options
            vim.opt.softtabstop         = 4
            vim.opt.shiftwidth          = 4
            vim.opt.expandtab           = true
            vim.smartindent             = true
            vim.opt.swapfile            = false -- cache directories
            vim.opt.backup              = false
            vim.opt.undodir             = vim.fn.stdpath('data') .. '/vim/undodir'
            vim.opt.undofile            = true
            vim.opt.hlsearch            = false -- search options
            vim.opt.incsearch           = true
            vim.opt.ignorecase          = true
            vim.opt.smartcase           = true
            vim.opt.wrap                = false -- misc options
            vim.opt.scrolloff           = 8
            vim.opt.signcolumn          = 'yes'
            vim.opt.updatetime          = 50
            vim.opt.colorcolumn         = '120'
            vim.g.mapleader             = ','
            vim.opt.termguicolors       = true
            vim.opt.cursorline          = true
            vim.g.loaded_netrw          = 1 -- disable netrw (garbage)
            vim.g.loaded_netrwPlugin    = 1
            vim.opt.isfname:append("@-@")
        '';

        programs.neovim.plugins = let
            nvim-treesitter-main = pkgs.vimUtils.buildVimPlugin {
                pname = "nvim-treesitter-main";
                version = "6e42d823ce0a5a76180c473c119c7677738a09d1";
                src = pkgs.fetchFromGitHub {
                    owner = "nvim-treesitter";
                    repo = "nvim-treesitter";
                    rev = "6e42d823ce0a5a76180c473c119c7677738a09d1";
                    sha256 = "sha256-wC0ZngirfJYLTJIydTwMwET1ucy6JEy28BoDmGPDN+k=";
                };
                nvimSkipModules = ["nvim-treesitter._meta.parsers"];
            };
        in [
        pkgs.vimPlugins.lualine-nvim
        {
            plugin = nvim-treesitter-main;
            type = "lua";
            config = ''
                require'nvim-treesitter'.setup {
                    install_dir = vim.fn.stdpath('data') .. '/nvim-treesitter',
                }
                require'nvim-treesitter'.install { 'rust', 'javascript', 'typescript', 'c' }
            '';
        }
        {
            plugin = pkgs.vimPlugins.telescope-nvim;
            type = "lua";
            config = ''
                local builtin = require('telescope.builtin')
                vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
                vim.keymap.set('n', '<C-p>', builtin.git_files, {})
                vim.keymap.set('n', '<leader>fs', function()
                    builtin.grep_string({ search = vim.fn.input("Grep > ") });
                end)
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
    };
}
