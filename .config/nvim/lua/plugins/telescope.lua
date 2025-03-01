return {
	{
		"nvim-telescope/telescope.nvim",
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
			local builtin = require("telescope.builtin")

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
						initial_mode = "normal",
						mappings = {
							n = {
								["d"] = actions.delete_buffer + actions.move_to_top,
							},
						},
					},
					diagnostics = {
						initial_mode = "normal",
					},
					lsp_references = {
						initial_mode = "normal",
					},
					lsp_document_symbols = {
						initial_mode = "normal",
					},
				},
				extensions = {
					fzf = {},
				},
			})

			telescope.load_extension("fzf")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, {
				desc = "[F]ind [F]iles",
			})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
				desc = "[F]ind by [G]rep",
			})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {
				desc = "[F]ind [B]uffers",
			})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
				desc = "[F]ind [H]elp",
			})
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {
				desc = "[F]ind [D]iagnostics",
			})
		end,
	},
}
