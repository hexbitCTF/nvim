return {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        -- Example keymaps for classic Harpoon
        vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon Add File" })
        vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon Menu" })

        -- Quick navigation bindings
        vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
        vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
        vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
        vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)
    end
}
