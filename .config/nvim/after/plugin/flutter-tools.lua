local config = require("config.lsp")

require("flutter-tools").setup({
  fvm = true,
  lsp = {
    color = {
      enabled = true,
      foreground = true,
      background = true,
      virtual_text = true,
      virtual_text_str = "■",
    },
    on_attach = config.on_attach,
  },
})
