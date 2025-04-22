local M = {}

local function setup_keymaps(buffer)
  local telescope_builtin = require("telescope.builtin")
  local neotree_command = require("neo-tree.command")

  -- For other lsp default keymaps use:
  -- :help lsp-defaults
  local keymaps = {
    { "gd", telescope_builtin.lsp_definitions,      desc = "[G]et [D]efinition" },
    { "gy", telescope_builtin.lsp_type_definitions, desc = "[G]et T[y]pe Definition" },
    { "gI", telescope_builtin.lsp_implementations,  desc = "[G]et [I]mplementations" },
    { "gr", telescope_builtin.lsp_references,       desc = "[G]et [R]eferences" },
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
    { "<leader>d",  vim.diagnostic.open_float, desc = "[D]iagnostic Float" },
    {
      "K",
      function()
        vim.lsp.buf.hover({ border = "rounded" })
      end,
      desc = "Hover"
    },
    {
      "<leader>fs",
      -- telescope_builtin.lsp_document_symbols,
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
    { "<leader>ca", vim.lsp.buf.code_action,   desc = "[C]ode [A]ction" },
    { "<leader>rn", vim.lsp.buf.rename,        desc = "[R]e[n]ame" },
    {
      "<leader>h",
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end,
      desc = "Inlay [H]int",
    },
  }

  for _, keys in ipairs(keymaps) do
    local lhs = keys[1]
    local rhs = keys[2]
    keys[1] = nil
    keys[2] = nil
    keys.buffer = buffer
    vim.keymap.set("n", lhs, rhs, keys)
  end
end

local function ts_sort_imports(client, buffer)
  local path = vim.api.nvim_buf_get_name(buffer)

  local ok = client.request("workspace/executeCommand", {
    command = "_typescript.organizeImports",
    arguments = { path },
  })
  if ok then
    vim.cmd([[:w]])
  end
end

function M.on_attach(client, buffer)
  setup_keymaps(buffer)
end

M.eslint = {
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = false,
      },
      showDocumentation = {
        enable = false,
      },
    },
  },
}

M.ts_ls = {
  on_attach = function(client, buffer)
    M.on_attach(client, buffer)

    -- sort imports
    vim.keymap.set("n", "<leader>si", function()
      ts_sort_imports(client, buffer)
    end, {
      buffer = buffer,
      desc = "[S]ort [I]mports",
    })
  end,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}

M.lua_ls = {
  settings = {
    Lua = {
      diagnostics = {
        disable = { "missing-fields" },
      },
    },
  },
}

return M
