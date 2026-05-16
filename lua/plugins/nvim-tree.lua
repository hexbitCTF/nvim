return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- This part makes the tree background transparent
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none", ctermbg = "none" })
    vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none", ctermbg = "none" })
    vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "none", ctermbg = "none" })

    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
      },
      -- Optional: removes the column that shows git/error icons if it still looks weird
      renderer = {
        group_empty = true,
      },
    })
  end,
}
