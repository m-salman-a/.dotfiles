local M = {}

local function setup_keymaps(buffer)
	local telescope_builtin = require("telescope.builtin")

	-- For other lsp default keymaps use:
	-- :help lsp-defaults
	local keymaps = {
		{ "gd", telescope_builtin.lsp_definitions, desc = "[G]et [D]efinition" },
		{ "gy", telescope_builtin.lsp_type_definitions, desc = "[G]et T[y]pe Definition" },
		{ "gI", telescope_builtin.lsp_implementations, desc = "[G]et [I]mplementations" },
		{ "gr", telescope_builtin.lsp_references, desc = "[G]et [R]eferences" },
		{
			"]d",
			function()
				vim.diagnostic.jump({ count = 1, float = true })
			end,
			desc = "[D]iagnostics Next",
		},
		{
			"[d",
			function()
				vim.diagnostic.jump({ count = -1, float = true })
			end,
			desc = "[D]iagnostics Previous",
		},
		{ "<leader>d", vim.diagnostic.open_float, desc = "[D]iagnostic Float" },
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

-- This is needed because closing a buffer removes all of its diagnostics from the diagnostics list.
local function populate_workspace_diagnostics_on_buffer_close(client, buffer)
	vim.api.nvim_create_autocmd("BufUnload", {
		buffer = buffer,
		once = true,
		callback = function()
			local path = vim.api.nvim_buf_get_name(buffer)
			local filetype = vim.filetype.match({ buf = buffer })
			local text = vim.fn.join(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), "\n")

			vim.defer_fn(function()
				client.notify(vim.lsp.protocol.Methods.textDocument_didOpen, {
					textDocument = {
						uri = vim.uri_from_fname(path),
						version = 0,
						text = text,
						languageId = filetype,
					},
				})
			end, 0)
		end,
	})
end

local function populate_workspace_diagnostics(client, buffer)
	require("workspace-diagnostics").populate_workspace_diagnostics(client, buffer)
	populate_workspace_diagnostics_on_buffer_close(client, buffer)
end

M.on_attach = function(client, buffer)
	setup_keymaps(buffer)
	populate_workspace_diagnostics(client, buffer)
end

M.lua_ls = {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
}

return M
