local handlers = require("config.lsp.handlers")

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

---@type vim.lsp.Config
return {
  on_attach = function(client, buffer)
    handlers.on_attach(client, buffer)

    -- sort imports
    vim.keymap.set("n", "<leader>si", function()
      ts_sort_imports(client, buffer)
    end, {
      buffer = buffer,
      desc = "[S]ort [I]mports",
    })
  end,
  ---@type lspconfig.settings.ts_ls
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
