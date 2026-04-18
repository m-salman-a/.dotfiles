return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local is_tree_open = false
      local command = require("neo-tree.command")

      ---@module "neo-tree"
      ---@type neotree.Config?
      require("neo-tree").setup({
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "document_symbols",
        },
        close_if_last_window = true,
        window = {
          width = 30,
          mappings = {
            ["<C-v>"] = "open_vsplit",
          },
        },
        filesystem = {
          filtered_items = {
            visible = true,
          },
        },
        default_component_configs = {
          git_status = {
            enabled = false,
          },
        },
        event_handlers = {
          -- Auto Close on Open File
          {
            event = "file_open_requested",
            handler = function()
              command.execute({ action = "close" })
            end,
          },
          -- Toggle neo-tree for all modes
          {
            event = "neo_tree_window_after_open",
            handler = function()
              is_tree_open = true
            end,
          },
          {
            event = "neo_tree_window_after_close",
            handler = function()
              is_tree_open = false
            end,
          },
        },
      })

      vim.keymap.set("n", "<leader>e", function()
        if is_tree_open then
          command.execute({ action = "close" })
        else
          command.execute({
            action = "focus",
            source = "filesystem",
            toggle = true,
            reveal = true,
          })
        end
      end, {
        desc = "File [E]xplorer",
      })
      vim.keymap.set("n", "<leader>fb", function()
        command.execute({
          action = "focus",
          source = "buffers",
          toggle = true,
          reveal = true,
        })
      end, {
        desc = "[F]ind [B]uffers",
      })
    end,
  },

  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = false,
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = false,
      },
    },
    lazy = false,
  },
}
