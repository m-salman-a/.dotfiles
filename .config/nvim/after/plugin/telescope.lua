local ok, telescope = pcall(require, "telescope")
if not ok then
	print("Telescope could not be initialized")
	return
end

local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		mappings = {
			n = {
				["q"] = actions.close,
			},
		},
	},
	pickers = {
		buffers = {
			mappings = {
				n = {
					["d"] = actions.delete_buffer + actions.move_to_top,
				},
			},
		},
	},
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
