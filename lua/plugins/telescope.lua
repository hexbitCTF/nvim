return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')

        -- Find Files (Including Hidden)
        vim.keymap.set('n', '<leader>ff', function()
            builtin.find_files({ 
                hidden = true, 
                no_ignore = false -- Set to true if you ALSO want to see .gitignore files
            })
        end, { desc = 'Telescope find files (hidden)' })

        -- Live Grep (Including Hidden)
        vim.keymap.set('n', '<leader>fg', function()
            builtin.live_grep({
                additional_args = function(args)
                    return { "--hidden" }
                end
            })
        end, { desc = 'Telescope live grep (hidden)' })
    end
}
