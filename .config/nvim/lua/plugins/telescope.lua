return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local telescope = require("telescope")
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
				extensions = {
					fzf = {},
				},
			})

			telescope.load_extension("fzf")

			vim.keymap.set("n", "<leader>ff", ":Telescope find_files <CR>")
			vim.keymap.set("n", "<leader>fg", ":Telescope live_grep <CR>")
			vim.keymap.set("n", "<leader>fb", ":Telescope buffers initial_mode=normal<CR>")
		end,
	},
}
