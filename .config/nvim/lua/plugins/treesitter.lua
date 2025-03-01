return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vimdoc",
					"vim",
					"dart",
					"javascript",
					"typescript",
					"tsx",
					"html",
					"css",
					"yaml",
					"json",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			vim.keymap.set("n", "[c", function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end, { noremap = true, silent = true })
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		enable = false,
		opts = {
			enable_autocmd = false,
		},
	},
}
