vim.o.background = "dark"

local has_catppuccin, catppuccin = pcall(require, "catppuccin")
if has_catppuccin then
	catppuccin.setup({
		flavour = "frappe",
		integrations = {
			cmp = true,
			gitsigns = true,
			mason = true,
			nvimtree = true,
			treesitter = true,
			telescope = {
				enabled = true,
			},
			native_lsp = {
				enabled = true,
			},
		},
	})

	vim.cmd([[colorscheme catppuccin]])
end
