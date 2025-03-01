return {
	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 1000,
					lsp_format = "fallback",
				},
			})

			vim.keymap.set("n", "<leader>fm", conform.format, {
				desc = "[F]or[m]at",
				silent = true,
			})
		end,
	},
}
