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
