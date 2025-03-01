local M = {}

M.get = function()
	local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")

	-- For other lsp default keymaps use:
	-- :help lsp-defaults
	return {
		{ "gd", "<C-]>", desc = "[G]et [D]efinition", remap = true },
		{ "gD", vim.lsp.buf.declaration, desc = "[G]et [D]eclaration" },
		{ "gy", vim.lsp.buf.type_definition, desc = "[G]et T[y]pe Definition" },
		{
			"gI",
			function()
				if has_telescope then
					telescope_builtin.lsp_implementations()
				else
					vim.lsp.buf.implementation()
				end
			end,
			desc = "[G]et [I]mplementations",
		},
		{
			"gr",
			function()
				if has_telescope then
					telescope_builtin.lsp_references()
				else
					vim.lsp.buf.references()
				end
			end,
			desc = "[G]et [R]eferences",
		},
		{
			"<leader>fs",
			function()
				if has_telescope then
					telescope_builtin.lsp_document_symbols()
				else
					vim.lsp.buf.document_symbol()
				end
			end,
			desc = "[F]ind [S]ymbols",
		},
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction" },
		{ "<leader>rn", vim.lsp.buf.rename, desc = "[R]e[n]ame" },
	}
end

return M
