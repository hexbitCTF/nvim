return {
    'nvim-telescope/telescope.nvim',
    lazy = false, -- Force loading on startup so dashboard commands work instantly
    dependencies = { 
        'nvim-lua/plenary.nvim',
        'debugloop/telescope-undo.nvim',
    },
    config = function()
        local builtin = require('telescope.builtin')
        local actions = require('telescope.actions')

        require('telescope').setup({
            defaults = {
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        preview_width = 0.55,
                        results_width = 0.45,
                    },
                    width = 0.85,
                    height = 0.80,
                    preview_cutoff = 10, 
                },
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                    n = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                },
            },
            extensions = {
                undo = {
                    side_by_side = true,
                    layout_strategy = "horizontal",
                    layout_config = {
                        preview_width = 0.65, 
                    },
                    mappings = {
                        i = {
                            ["<cr>"] = require("telescope-undo.actions").restore,
                        },
                        n = {
                            ["<cr>"] = require("telescope-undo.actions").restore,
                        },
                    },
                },
            },
        })

        require("telescope").load_extension("undo")

        -- Map keybindings directly
        vim.keymap.set('n', '<leader>ff', function()
            builtin.find_files({ hidden = true, no_ignore = false })
        end, { desc = 'Telescope find files (hidden)' })

        vim.keymap.set('n', '<leader>fg', function()
            builtin.live_grep({
                additional_args = function() return { "--hidden" } end
            })
        end, { desc = 'Telescope live grep (hidden)' })

        vim.keymap.set('n', '<leader>u', '<cmd>Telescope undo<cr>', { desc = 'Telescope Undo History' })
    end
}
