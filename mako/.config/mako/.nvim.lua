-- Auto-reload mako configuration when config file is saved
vim.notify(".nvim found, auto-reload mako config", vim.log.levels.INFO)

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*/mako/config", vim.fn.expand("~/.config/mako/config") },
	callback = function()
		-- Check if makoctl is available and mako is running
		local result = vim.fn.system("which makoctl")
		if vim.v.shell_error ~= 0 then
			vim.notify("makoctl command not found", vim.log.levels.ERROR)
			return
		end

		-- Reload mako configuration
		local reload_result = vim.fn.system("makoctl reload 2>&1")
		if vim.v.shell_error == 0 then
			vim.notify("Mako configuration reloaded successfully", vim.log.levels.INFO)
		else
			vim.notify("Failed to reload mako: " .. reload_result, vim.log.levels.ERROR)
		end
	end,
})
