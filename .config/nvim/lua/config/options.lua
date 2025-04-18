vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = "yes"

vim.o.swapfile = false

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.o.termguicolors = true

vim.o.scrolloff = 8

vim.o.cursorline = true
vim.o.cursorlineopt = "number"

vim.o.updatetime = 50

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = false

vim.o.ch = 1

vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
})
