if vim.g.vscode then
	require("config.vscode")
	return
end

require("config.options")
require("config.keymaps")
require("config.plugins")
