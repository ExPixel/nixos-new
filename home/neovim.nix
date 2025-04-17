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
    };
}