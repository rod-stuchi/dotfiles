-- Auto-reload configuration when config file is saved
vim.notify(".nvim found, waybar will be reloaded via SIGUSR2 on each save", vim.log.levels.INFO)

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*/waybar/*",
	callback = function()
		local result = vim.fn.system("which waybar")
		if vim.v.shell_error ~= 0 then
			vim.notify("waybar command not found", vim.log.levels.ERROR)
			return
		end

		-- Reload waybar config (waybar runs as a systemd user service)
		local reload_result = vim.fn.system("killall -SIGUSR2 waybar 2>&1")
		if vim.v.shell_error == 0 then
			vim.notify("Waybar reloaded successfully", vim.log.levels.INFO)
		else
			vim.notify("Failed to reload: " .. reload_result, vim.log.levels.ERROR)
		end
	end,
})
