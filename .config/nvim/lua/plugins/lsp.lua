local servers = { "lua_ls", "ts_ls", "jsonls" }

local on_attach = function(_, buffer)
	local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
	local opts = { noremap = true, silent = true, buffer = buffer }

	-- For other defaults use:
	-- :help lsp-defaults

	vim.keymap.set("n", "gd", "<C-]>")
	vim.keymap.set("n", "gI", function()
		if has_telescope then
			telescope_builtin.lsp_implementations()
		else
			vim.lsp.buf.implementation()
		end
	end, opts)
	vim.keymap.set("n", "gr", function()
		if has_telescope then
			telescope_builtin.lsp_references()
		else
			vim.lsp.buf.references()
		end
	end, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<leader>fs", function()
		if has_telescope then
			telescope_builtin.lsp_document_symbols()
		else
			vim.lsp.buf.document_symbol()
		end
	end, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
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
