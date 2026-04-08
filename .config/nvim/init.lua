if vim.g.vscode then
  -- require("config.vscode")
  -- require("config.plugins")
  return
end

require("config.options")
require("config.keymaps")
require("config.plugins")

