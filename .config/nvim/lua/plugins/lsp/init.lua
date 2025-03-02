local servers = { "lua_ls", "ts_ls", "jsonls" }

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
			for _, server in ipairs(servers) do
				local handlers = require("plugins.lsp.handlers")
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				require("lspconfig")[server].setup(vim.tbl_deep_extend("force", handlers[server] or {}, {
					capabilities = capabilities,
					on_attach = handlers.on_attach,
				}))
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
}
