return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				view = {
					relativenumber = true,
				},
				update_focused_file = {
					enable = true,
				},
			})

			local api = require("nvim-tree.api")

			-- Automatically close
			vim.api.nvim_create_autocmd({ "QuitPre" }, {
				callback = function()
					api.tree.close()
				end,
			})

			-- Automatically open file upon creation
			api.events.subscribe(api.events.Event.FileCreated, function(file)
				vim.cmd("edit " .. file.fname)
			end)

			vim.keymap.set("n", "<leader>e", api.tree.toggle, {
				desc = "File [E]xplorer",
			})
			vim.keymap.set("n", "zM", api.tree.collapse_all, {
				desc = "Fold All",
			})
		end,
	},
}
