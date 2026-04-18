---@type vim.lsp.Config
return {
  settings = {
    ---@type lspconfig.settings.eslint
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
