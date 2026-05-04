local config = require("config.lsp")

require("flutter-tools").setup({
  fvm = true,
  lsp = {
    on_attach = config.on_attach,
  },
})
