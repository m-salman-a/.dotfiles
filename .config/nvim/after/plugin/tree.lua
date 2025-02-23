local has_tree, nvimtree = pcall(require, "nvim-tree")
if not has_tree then
	print("File tree could not be initialized")
	return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup({
	view = {
		relativenumber = true,
	},
	update_focused_file = {
		enable = true,
	},
})

-- Automatically close
vim.api.nvim_create_autocmd({ "QuitPre" }, {
	callback = function()
		vim.cmd("NvimTreeClose")
	end,
})

-- Automatically open file upon creation
local api = require("nvim-tree.api")
api.events.subscribe(api.events.Event.FileCreated, function(file)
	vim.cmd("edit " .. file.fname)
end)

local has_lsp_file_operations, lsp_file_operations = pcall(require, "lsp-file-operations")
if not has_lsp_file_operations then
	return
end

lsp_file_operations.setup()
