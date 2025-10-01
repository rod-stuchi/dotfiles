-- Auto-reload configuration when config file is saved
vim.notify(".nvim found, pkill and waybar & disown will be exeucte on each save", vim.log.levels.INFO)

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*/waybar/*",
	callback = function()
		local result = vim.fn.system("which waybar")
		if vim.v.shell_error ~= 0 then
			vim.notify("waybar command not found", vim.log.levels.ERROR)
			return
		end

		-- Reload mako configuration
		vim.fn.system("pkill waybar 2>&1")
		local reload_result = vim.fn.system("waybar & disown 2>&1")
		if vim.v.shell_error == 0 then
			vim.notify("Waybar reloaded successfully", vim.log.levels.INFO)
		else
			vim.notify("Failed to reload: " .. reload_result, vim.log.levels.ERROR)
		end
	end,
})
