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

			-- Automatically close
			vim.api.nvim_create_autocmd({ "QuitPre" }, {
				callback = function()
					vim.cmd("NvimTreeClose")
				end,
			})

			-- Automatically open file upon creation
			local api = require("nvim-tree.api")
			api.events.subscribe(api.events.Event.FileCreated, function(file)
				vim.cmd("edit " .. file.fname)
			end)

			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {
				desc = "File [E]xplorer",
				silent = true,
			})
		end,
	},
}
