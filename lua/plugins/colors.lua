return {
    {
        "folke/tokyonight.nvim",
        lazy = false,    -- Make sure the theme loads immediately
        priority = 1000, -- Load this before everything else
        config = function()
            require("tokyonight").setup({
                style = "night",     -- Or "night", "moon", "day"
                transparent = true,  -- This is the magic line
                styles = {
                    sidebars = "transparent", -- Makes nvim-tree transparent
                    floats = "transparent",   -- Makes popups transparent
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
                -- This ensures the status bar background matches the transparency
                section_separators = '',
                component_separators = '',
            }
        }
    }
}
