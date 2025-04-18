local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ import = "plugins" },

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme catppuccin-frappe]])
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"echasnovski/mini.surround",
		version = false,
		opts = {},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				component_separators = { left = "|", right = "|" },
				section_separators = { left = " ", right = " " },
			},
			sections = {
				lualine_b = { "filename" },
				lualine_c = { "" },
				lualine_x = { "" },
				lualine_y = { "" },
			},
			extensions = { "neo-tree" },
		},
	},
}

require("lazy").setup(plugins, {
	ui = {
		border = "rounded",
	},
	dev = {
		path = "~/Developer",
	},
})
