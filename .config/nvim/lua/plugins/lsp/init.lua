local servers = { "lua_ls", "ts_ls", "eslint", "jsonls" }

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
			-- These need to be loaded first.
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local handlers = require("plugins.lsp.handlers")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = handlers.on_attach,
				}, handlers[server] or {}))
			end
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
		config = function()
			local handlers = require("plugins.lsp.handlers")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("flutter-tools").setup({
				fvm = true,
				lsp = {
					color = {
						enabled = true,
						virtual_text = true,
					},
					cmd = { "fvm", "dart", "language-server", "--protocol=lsp" },
					on_attach = handlers.on_attach,
					capabilities = capabilities,
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						analysisExcludedFolders = {
							vim.env.HOME .. "/.fvm",
							vim.env.HOME .. "/.pub-cache",
						},
						renameFilesWithClasses = "prompt",
						updateImportsOnRename = true,
					},
				},
				closing_tags = {
					enabled = false,
				},
			})
		end,
	},

	{
		"pmizio/typescript-tools.nvim",
		enabled = false,
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			local handlers = require("plugins.lsp.handlers")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("typescript-tools").setup({
				on_attach = function(client, buffer)
					handlers.on_attach(client, buffer)
					vim.keymap.set("n", "<leader>si", "<cmd>TSToolsOrganizeImports<CR>", {
						buffer = buffer,
						desc = "[S]ort [I]mports",
					})
				end,
				capabilities = capabilities,
			})
		end,
	},

	{
		"artemave/workspace-diagnostics.nvim",
		enabled = false,
		config = function()
			-- Fixes this bug
			-- https://github.com/artemave/workspace-diagnostics.nvim/issues/1
			vim.filetype.add({
				extension = {
					ts = "typescript",
				},
			})
		end,
	},
}
