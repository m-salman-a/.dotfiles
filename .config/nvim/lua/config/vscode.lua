if not vim.g.vscode then
  return
end

vim.o.cmdheight = 2

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 100
vim.o.swapfile = false

local vscode = require("vscode")

local opts = { silent = true, noremap = true }

-- Insert mode - trigger suggest
vim.keymap.set("i", "<C-n>", function()
  vscode.call("editor.action.triggerSuggest")
end, opts)

-- Diagnostic navigation
vim.keymap.set("n", "[d", function()
  vscode.call("editor.action.marker.prev")
end, opts)
vim.keymap.set("n", "]d", function()
  vscode.call("editor.action.marker.next")
end, opts)

-- Folding
vim.keymap.set("n", "zc", function()
  vscode.call("editor.fold")
end, opts)
vim.keymap.set("n", "zo", function()
  vscode.call("editor.unfold")
end, opts)
vim.keymap.set("n", "zC", function()
  vscode.call("editor.foldRecursively")
end, opts)
vim.keymap.set("n", "zO", function()
  vscode.call("editor.unfoldRecursively")
end, opts)
vim.keymap.set("n", "zM", function()
  vscode.call("editor.foldAll")
end, opts)
vim.keymap.set("n", "zR", function()
  vscode.call("editor.unfoldAll")
end, opts)
vim.keymap.set("n", "za", function()
  vscode.call("editor.toggleFold")
end, opts)

-- Folding Navigation
-- from here https://github.com/vscode-neovim/vscode-neovim/issues/58#issuecomment-1229279216
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = false, silent = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = false, silent = true })
