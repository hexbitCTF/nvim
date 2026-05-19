return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'saadparwaiz1/cmp_luasnip',
        { 'L3MON4D3/LuaSnip', version = "v2.*" },
    },
    config = function()
        -- 1. Setup Neodev for the 'vim' global
        require('neodev').setup({})

        -- 2. Setup Mason
        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { "lua_ls", "pyright", "clangd", "bashls" }, 
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

        -- Automatically start configured servers
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('pyright')
        vim.lsp.enable('clangd')
        vim.lsp.enable('bashls')

        -- 4. Simple Keybindings
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local opts = { buffer = args.buf }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            end,
        })

        -- 5. Updated CMP Setup with j/k navigation
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sources = { 
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
            mapping = cmp.mapping.preset.insert({
                -- Accept completion item
                ['<CR>'] = cmp.mapping.confirm({ select = true }),

                -- Navigate down the menu with Ctrl+j
                ['<C-j>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                -- Navigate up the menu with Ctrl+k
                ['<C-k>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
        })
    end
}
