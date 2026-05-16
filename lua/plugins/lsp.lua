return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        -- 1. Setup Neodev for the 'vim' global
        require('neodev').setup({})

        -- 2. Setup Mason
        require('mason').setup({})
        require('mason-lspconfig').setup({
            -- ADDED "pyright" HERE
            ensure_installed = { "lua_ls", "pyright" }, 
        })

        -- 3. THE NEW 0.11+ WAY
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

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

        -- --- PYTHON CONFIG (ADDED THIS) ---
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

        -- Automatically start configured servers
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('pyright') -- ENABLE PYTHON HERE

        -- 4. Simple Keybindings
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local opts = { buffer = args.buf }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                -- Added Rename (super useful for Python)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            end,
        })

        -- 5. Minimal CMP Setup
        local cmp = require('cmp')
        cmp.setup({
            sources = { { name = 'nvim_lsp' } },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
        })
    end
}
