local servers = { "lua_ls", "eslint", "ts_ls", "jsonls" }

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "rounded" },
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
      -- "hrsh7th/cmp-nvim-lsp",
      "saghen/blink.cmp",
      "folke/lazydev.nvim",
    },
    config = function()
      local handlers = require("plugins.lsp.handlers")
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
        vim.lsp.config(server, vim.tbl_deep_extend("force", {
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
      -- "nvim-tree/nvim-tree.lua",
      "nvim-neo-tree/neo-tree.nvim",
    },
    opts = {},
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library" },
      },
      -- disable when a .luarc.json file is found
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
  },

  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "hrsh7th/cmp-nvim-lsp",
      "saghen/blink.cmp",
    },
    config = function()
      local handlers = require("plugins.lsp.handlers")
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

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
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      -- "hrsh7th/cmp-nvim-lsp",
      "saghen/blink.cmp",
    },
    config = function()
      local handlers = require("plugins.lsp.handlers")
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

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

  {
    "nvimtools/none-ls.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      require("null-ls").setup({
        sources = {
          require("none-ls.diagnostics.eslint_d"),
        },
      })
    end,
  },
}
