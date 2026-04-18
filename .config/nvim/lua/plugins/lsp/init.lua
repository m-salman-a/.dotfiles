local servers = { "lua_ls", "ts_ls", "jsonls", "bashls" }

return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
    },
    lazy = false,
    config = function()
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("ts_ls")
    end,
  },

  {
    "antosha417/nvim-lsp-file-operations",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    opts = {},
  },

  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local handlers = require("plugins.lsp.handlers")
      local capabilities = {}

      local blink_ok, blink = pcall(require, "blink.cmp")
      if blink_ok then
        capabilities = blink.get_lsp_capabilities()
      end

      require("flutter-tools").setup({
        fvm = true,
        lsp = {
          color = {
            enabled = true,
            virtual_text = true,
          },
          on_attach = handlers.on_attach,
          capabilities = capabilities,
          settings = {
            showTodos = true,
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
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      require("null-ls").setup({
        sources = {
          -- This works better than eslint_d and eslint lsp from Mason.
          require("none-ls.diagnostics.eslint"),
        },
      })
    end,
  },
}
