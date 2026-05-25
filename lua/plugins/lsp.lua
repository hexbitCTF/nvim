return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'folke/neodev.nvim',
            'hrsh7th/nvim-cmp',
	    'hrsh7th/cmp-nvim-lsp',
	    'saadparwaiz1/cmp_luasnip',
	    { 'L3MON4D3/LuaSnip', version = "v2.*" },
	    'rafamadriz/friendly-snippets', 
	    'stevearc/dressing.nvim',
    },
    config = function()
	    -- 1. Setup Neodev for the 'vim' global
	    require('neodev').setup({})

            -- 2. Setup Mason
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { "lua_ls", "pyright", "clangd", "bashls", "ruff", "html", "cssls" }, 
            })

            -- 3. THE 0.11+ CAPABILITIES FIX
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities()
            )

            -- --- LUA CONFIG ---
            vim.lsp.config('lua_ls', {
                cmd = { 'lua-language-server' },
                filetypes = { 'lua' },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        diagnostics = { globals = { 'vim' } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })

            -- --- PYTHON CONFIG ---
            vim.lsp.config('pyright', {
                cmd = { 'pyright-langserver', '--stdio' },
                filetypes = { 'python' },
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                    },
                },
            })

            -- --- C / C++ CONFIG ---
            vim.lsp.config('clangd', {
                cmd = { 'clangd' },
                filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
                capabilities = capabilities,
            })

            -- --- BASH CONFIG ---
            vim.lsp.config('bashls', {
                cmd = { 'bash-language-server', 'start' },
                filetypes = { 'sh' },
                capabilities = capabilities,
            })

            -- --- HTML CONFIG ---
            vim.lsp.config('html', {
                cmd = { 'vscode-html-language-server', '--stdio' },
                filetypes = { 'html', 'temple' },
                capabilities = capabilities,
            })

            -- --- CSS CONFIG ---
            vim.lsp.config('cssls', {
                cmd = { 'vscode-css-language-server', '--stdio' },
                filetypes = { 'css', 'scss', 'less' },
                capabilities = capabilities,
            })

            -- Automatically start configured servers
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('pyright')
            vim.lsp.enable('ruff')    
            vim.lsp.enable('clangd')
            vim.lsp.enable('bashls')
            vim.lsp.enable('html')   
            vim.lsp.enable('cssls')  

            -- 4. Simple Keybindings & Hover/CodeAction Border Configuration
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    
                    vim.keymap.set('n', 'K', function()
                        vim.lsp.buf.hover({ border = "rounded" })
                    end, opts)

                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                end,
            })

            local severity = vim.diagnostic.severity

            vim.diagnostic.config({
                signs = {
                    text = {
                        [severity.ERROR] = " ",
                        [severity.WARN] = " ",
                        [severity.HINT] = "󰠠 ",
                        [severity.INFO] = " ",
                    },
                },
            })

            -- Force floating windows to use opaque colors when the colorscheme changes
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#16161e", fg = "#c0caf5" })
                    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#16161e", fg = "#7aa2f7" })
                end,
            })

            -- 5. Updated CMP Setup with friendly-snippets loader
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            -- Added: This tells LuaSnip to look inside friendly-snippets and load HTML/CSS profiles
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    documentation = cmp.config.window.bordered(),
                    completion = cmp.config.window.bordered(),
                },
                sources = { 
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- This source feeds the snippets directly into your menu
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),

                    ['<C-j>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),

                    ['<C-k>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
            })
        end
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,    
        priority = 1000, 
        config = function()
            require("tokyonight").setup({
                style = "night",     
                transparent = true,  
                styles = {
                    sidebars = "transparent", 
                    floats = "transparent",   
                },
            })
            vim.cmd.colorscheme "tokyonight"
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = 'tokyonight',
                section_separators = '',
                component_separators = '',
            }
        }
    }
}
