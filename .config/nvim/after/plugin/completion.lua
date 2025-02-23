local has_completions, cmp = pcall(require, "cmp")
if not has_completions then
	print("Completions could not be initialized")
	return
end

local has_snip, snip = pcall(require, "luasnip")
if not has_snip then
	print("Snipping engine could not be initialized")
	return
end

require("luasnip.loaders.from_vscode").lazy_load()

local cmp_kinds = {
	Text = " ",
	Method = " ",
	Function = " ",
	Constructor = " ",
	Field = " ",
	Variable = " ",
	Class = " ",
	Interface = " ",
	Module = " ",
	Property = " ",
	Unit = " ",
	Value = " ",
	Enum = " ",
	Keyword = " ",
	Snippet = " ",
	Color = " ",
	File = " ",
	Reference = " ",
	Folder = " ",
	EnumMember = " ",
	Constant = " ",
	Struct = " ",
	Event = " ",
	Operator = " ",
	TypeParameter = " ",
}

cmp.setup({
	snippet = {
		expand = function(args)
			snip.lsp_expand(args.body) -- For `luasnip` users
		end,
	},
	formatting = {
		fields = { "kind", "abbr" },
		format = function(_, vim_item)
			vim_item.kind = cmp_kinds[vim_item.kind] or ""
			return vim_item
		end,
	},
	mapping = cmp.mapping.preset.insert({
		-- Safely select entries with <CR>
		["<CR>"] = cmp.mapping(function(fallback)
			if cmp.visible() and cmp.get_active_entry() then
				if snip.expandable() then
					snip.expand()
				else
					cmp.confirm({ select = true })
				end
			else
				fallback()
			end
		end),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif snip.locally_jumpable(1) then
				snip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif snip.locally_jumpable(-1) then
				snip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

local has_autopairs = require("nvim-autopairs")
if not has_autopairs then
	print("Autopairs completion could not be initialized")
	return
end

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
