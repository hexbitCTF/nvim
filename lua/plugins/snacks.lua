return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files hidden=true" },
          { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep additional_args={--hidden}" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "c", desc = "Config", action = ":lua require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config'), hidden = true})" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      formats = {
        header = { align = "center" },
        keys   = { align = "center" },
      },
    },
  },
}
