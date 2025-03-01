local has_tree, nvimtree = pcall(require, "nvim-tree")
if not has_tree then
	print("File tree could not be initialized")
	return
end

local has_lsp_file_operations, lsp_file_operations = pcall(require, "lsp-file-operations")
if not has_lsp_file_operations then
	return
end

lsp_file_operations.setup()
