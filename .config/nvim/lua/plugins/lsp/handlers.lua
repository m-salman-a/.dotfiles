local M = {}

M.on_attach = function(client, buffer)
	local telescope_builtin = require("telescope.builtin")

	-- For other lsp default keymaps use:
	-- :help lsp-defaults
	local keymaps = {
		{ "gd", telescope_builtin.lsp_definitions, desc = "[G]et [D]efinition" },
		{ "gy", telescope_builtin.lsp_type_definitions, desc = "[G]et T[y]pe Definition" },
		{ "gI", telescope_builtin.lsp_implementations, desc = "[G]et [I]mplementations" },
		{ "gr", telescope_builtin.lsp_references, desc = "[G]et [R]eferences" },
		{ "<leader>fs", telescope_builtin.lsp_document_symbols, desc = "[F]ind [S]ymbols" },
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction" },
		{ "<leader>rn", vim.lsp.buf.rename, desc = "[R]e[n]ame" },
	}

	for _, keys in ipairs(keymaps) do
		local lhs = keys[1]
		local rhs = keys[2]
		keys[1] = nil
		keys[2] = nil
		keys.buffer = buffer
		vim.keymap.set("n", lhs, rhs, keys)
	end
end

return M
