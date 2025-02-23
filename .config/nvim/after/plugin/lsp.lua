local has_mason, mason = pcall(require, "mason")
if not has_mason then
	print("Mason could not be initialized")
end

local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not has_mason_lspconfig then
	print("Mason-lspconfig could not be initialized")
end

local servers = { "lua_ls", "ts_ls", "jsonls" }

if has_mason and has_mason_lspconfig then
	mason.setup({
		ui = {
			border = "rounded",
		},
	})

	mason_lspconfig.setup({
		ensure_installed = servers,
	})
end

local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if not has_lspconfig then
	print("Lspconfig could not be initialized")
	return
end

local capabilities = {}
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
	capabilities = cmp_nvim_lsp.default_capabilities()
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
	end

	nmap("<Leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap("<Leader>rn", vim.lsp.buf.rename, "[R]e[n]ame)")

	-- Diagnostics
	nmap("]d", function()
		vim.diagnostic.goto_next({ buffer = 0 })
	end, "Go to next [d]iagnostic message")
	nmap("[d", function()
		vim.diagnostic.goto_prev({ buffer = 0 })
	end, "Go to previous [d]iagnostic message")
	nmap("gl", vim.diagnostic.open_float, "Open [D]iagnostic [F]loating message")
	nmap("<Leader>fd", function()
		local has_telescope = pcall(require, "telescope")
		if has_telescope then
			require("telescope.builtin").diagnostics({ initial_mode = "normal" })
		end
	end, "[F]ind [D]iagnostics")

	-- Signature
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Goto
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gr", function()
		local has_telescope = pcall(require, "telescope")
		if has_telescope then
			require("telescope.builtin").lsp_references({ initial_mode = "normal" })
		else
			vim.lsp.buf.references()
		end
	end, "[G]oto [R]eferences")
	nmap("<Leader>fs", function()
		local has_telescope = pcall(require, "telescope")
		if has_telescope then
			require("telescope.builtin").lsp_document_symbols()
		else
			vim.lsp.buf.document_symbol()
		end
	end, "[F]ind [S]ymbols")

	-- Format
	nmap("<Leader>fm", function()
		local has_conform, conform = pcall(require, "conform")
		if has_conform then
			conform.format()
		else
			vim.lsp.buf.format()
		end
	end)

	-- Less used
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [Declaration]")
	nmap("<Leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
end

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
})

lspconfig.ts_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

local has_flutter_tools, flutter_tools = pcall(require, "flutter-tools")
if not has_flutter_tools then
	print("Flutter-tools could not be initialized")
	return
end

flutter_tools.setup({
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
})
