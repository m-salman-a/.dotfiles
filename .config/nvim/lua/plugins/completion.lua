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
    version = "v2.*",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "saghen/blink.cmp",
    dependencies = { "L3MON4D3/LuaSnip", "folke/lazydev.nvim" },
    version = "1.*",
    config = function()
      local blink = require("blink-cmp")

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      blink.setup({
        snippets = {
          preset = "luasnip",
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        appearance = {
          kind_icons = cmp_kinds,
        },
        signature = {
          enabled = true,
        },
        completion = {
          list = {
            selection = {
              preselect = false,
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
          accept = {
            -- Auto brackets sometimes stops LSP signature help from showing. Disabling for now.
            auto_brackets = {
              enabled = false,
            },
          },
          menu = {
            draw = {
              treesitter = { "lsp" },
              columns = { { "kind_icon" }, { "label", "label_description" }, { "source_name" } },
              components = {
                source_name = {
                  text = function(ctx)
                    return "[" .. ctx.source_name .. "]"
                  end,
                },
              },
            },
          },
        },
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

      vim.keymap.set("i", "<C-n>", blink.show, { desc = "Show completions" })
    end,
  },

  {
    "r5n-labs/vscode-react-javascript-snippets",
    build = "yarn install --frozen-lockfile && yarn compile",
  },
}
