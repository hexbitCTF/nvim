return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      preset = {
        keys = {
          { 
            icon = " ", 
            key = "f", 
            desc = "Find File", 
            action = function() require('telescope.builtin').find_files({ hidden = true }) end 
          },
          { 
            icon = " ", 
            key = "g", 
            desc = "Find Text", 
            action = function() 
              require('telescope.builtin').live_grep({
                additional_args = function() return { "--hidden" } end
              }) 
            end 
          },
          { 
            icon = " ", 
            key = "r", 
            desc = "Recent Files", 
            action = function() require('telescope.builtin').oldfiles() end 
          },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { 
            icon = " ", 
            key = "c", 
            desc = "Config", 
            action = function() require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config'), hidden = true }) end 
          },
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
