vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
-- Pressing 'Space + e' will open/close the file explorer
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- Start Live Server in the background with <leader>ls
vim.keymap.set('n', '<leader>ls', function()
    vim.fn.jobstart('live-server --port=5500', { detach = true })
    print("Live Server started on port 5500...")
end, { desc = "Start Live Server" })








