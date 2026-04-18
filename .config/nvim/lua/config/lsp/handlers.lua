local M = {}

local function setup_keymaps(buffer)
  local telescope_builtin = require("telescope.builtin")
  local neotree_command = require("neo-tree.command")

  -- For other lsp default keymaps use:
  -- :help lsp-defaults
  -- stylua: ignore start
  local keymaps = {
    { "gd", telescope_builtin.lsp_definitions, desc = "[G]et [D]efinition" },
    {
      "]d",
      function()
        vim.diagnostic.jump({ count = 1, float = true })
      end,
      desc = "[D]iagnostics Next",
    },
    {
      "[d",
      function()
        vim.diagnostic.jump({ count = -1, float = true })
      end,
      desc = "[D]iagnostics Previous",
    },
    {
      "<leader>fs",
      function()
        neotree_command.execute({
          action = "focus",
          source = "document_symbols",
          toggle = true,
          reveal = true,
          follow_cursor = true,
        })
      end,
      desc = "[F]ind [S]ymbols",
    },
    {
      "<leader>h",
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end,
      desc = "Inlay [H]int",
    },
  }
  -- stylua: ignore end

  for _, keys in ipairs(keymaps) do
    local lhs = keys[1]
    local rhs = keys[2]
    keys[1] = nil
    keys[2] = nil
    keys.buffer = buffer
    vim.keymap.set("n", lhs, rhs, keys)
  end
end

function M.on_attach(client, buffer)
  setup_keymaps(buffer)
end

return M
