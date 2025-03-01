local servers = { "lua_ls", "ts_ls", "jsonls" }

local handlers = require("plugins.lsp.handlers")

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
			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup(vim.tbl_deep_extend("force", handlers[server] or {}, {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
		opts = {
			fvm = true,
			lsp = {
				color = {
					enabled = true,
					virtual_text = true,
				},
				on_attach = handlers.on_attach,
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
