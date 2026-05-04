local config = require("config.lsp")

---@type vim.lsp.Config
return {
  on_attach = config.on_attach,
}
