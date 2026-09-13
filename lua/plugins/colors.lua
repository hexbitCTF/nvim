return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = 'auto',
                -- This ensures the status bar background matches the transparency
                section_separators = '',
                component_separators = '',
            }
        }
    }
}