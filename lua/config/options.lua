vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"



-- Save file as root using sudo or doas
vim.api.nvim_create_user_command('W', function()
	-- Check if the current buffer has a file name
	local file = vim.fn.expand('%:p')
	if file == '' then
		vim.notify("No file name", vim.log.levels.ERROR)
		return
	end

	-- Choose your privilege escalation utility ('doas' or 'sudo')
	local elevator = "doas" 

	-- Construct the command to write the buffer via tee
	local cmd = string.format("w !%s tee %% > /dev/null", elevator)

	-- Execute the write command
	vim.cmd(cmd)

	-- Reload the file to clear the read-only status and update the buffer
	vim.cmd("e!")
end, {})










