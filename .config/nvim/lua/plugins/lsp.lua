local servers = { "lua_ls", "ts_ls", "jsonls" }

local on_attach = function(_, buffer)
	local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
	local keymaps = {
		{ "gd", vim.lsp.buf.definition, desc = "[G]et [D]efinition" },
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

	-- For other defaults use:
	-- :help lsp-defaults

	for _, keys in ipairs(keymaps) do
		local lhs = keys[1]
		local rhs = keys[2]
		keys[1] = nil
		keys[2] = nil
		keys.buffer = buffer
		vim.keymap.set("n", lhs, rhs, keys)
	end
end

return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = servers,
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
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
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.jsonls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
	},

	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		opts = {},
	},

	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			fvm = true,
			lsp = {
				color = {
					enabled = true,
					virtual_text = true,
				},
				on_attach = on_attach,
				settings = {
					renameFilesWithClasses = "prompt",
					analysisExcludedFolders = {
						vim.env.HOME .. "/.fvm",
						vim.env.HOME .. "/.pub-cache",
					},
					completeFunctionCalls = true,
					updateImportsOnRename = true,
					showTodos = true,
				},
			},
			closing_tags = {
				enabled = false,
			},
		},
	},
}
