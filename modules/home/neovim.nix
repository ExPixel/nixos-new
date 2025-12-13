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
        programs.neovim.extraLuaConfig = ''
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
        programs.neovim.plugins = [
        pkgs.vimPlugins.lualine-nvim
        {
            plugin = pkgs.vimPlugins.nvim-treesitter;
            type = "lua";
            config = ''
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