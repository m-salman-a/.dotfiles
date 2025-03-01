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
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
}
