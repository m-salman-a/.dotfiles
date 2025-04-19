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

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "r5n-labs/vscode-react-javascript-snippets",
    },
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

	{
		"hrsh7th/nvim-cmp",
		enabled = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"folke/lazydev.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local snip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            snip.lsp_expand(args.body)
          end,
        },
        formatting = {
          fields = { "kind", "abbr" },
          format = function(_, vim_item)
            vim_item.kind = cmp_kinds[vim_item.kind] or ""
            return vim_item
          end,
          expandable_indicator = true,
        },
        sources = cmp.config.sources({
          { name = "lazydev" },
        }, {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
        }, {
          { name = "path" },
          { name = "buffer" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-x>"] = cmp.mapping.abort(),

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
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

	{
		"saghen/blink.cmp",
		-- enabled = false,
		dependencies = { "L3MON4D3/LuaSnip", "folke/lazydev.nvim" },
		version = "1.*",
		config = function()
			local blink = require("blink-cmp")

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      blink.setup({
        completion = {
          menu = {
            draw = {
              components = {
                kind_icon = {
                  text = function(ctx)
                    return " " .. cmp_kinds[ctx.kind] or ctx.kind_icon .. ctx.icon_gap .. " "
                  end,
                },
              },
            },
          },
        },
        snippets = { preset = "luasnip" },
        sources = {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
        signature = { enabled = true },
        keymap = {
          preset = "super-tab",

          ["<Tab>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.snippet_forward()
              else
                return cmp.select_next()
              end
            end,
            "snippet_forward",
            "fallback",
          },

          ["<S-Tab>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.snippet_backward()
              else
                return cmp.select_prev()
              end
            end,
            "snippet_backward",
            "fallback",
          },

          ["<CR>"] = { "accept", "fallback" },
        },
      })

      vim.keymap.set("i", "<C-n>", function()
        blink.show()
      end, {
        desc = "Show completions",
      })
    end,
  },

  {
    "r5n-labs/vscode-react-javascript-snippets",
    build = "yarn install --frozen-lockfile && yarn compile",
  },
}
