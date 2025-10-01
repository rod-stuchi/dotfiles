require("relative-motions"):setup({
	show_numbers = "relative_absolute",
	show_motion = true,
})

require("session"):setup({
	sync_yanked = true,
})

require("zoxide"):setup({
	update_db = true,
})

require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode = "dir" },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

-- ref.: https://github.com/sxyazi/yazi/discussions/1643#discussioncomment-14385573

-- function Linemode:mtime()
-- 	local time = math.floor(self._file.cha.mtime or 0)
-- 	if time == 0 then
-- 		return ""
-- 	elseif os.date("%Y", time) == os.date("%Y") then
-- 		return os.date("%m/%d %H:%M", time)
-- 	else
-- 		return os.date("%m/%d  %Y", time)
-- 	end
-- end
