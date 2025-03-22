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

	{ "echasnovski/mini.surround", version = false, opts = {} },
}

require("lazy").setup(plugins, {
	ui = {
		border = "rounded",
	},
	dev = {
		path = "~/Developer",
	},
})
