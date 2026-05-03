local M = {}

M.on_attach = function(client, bufnr)
  local opts = { silent = true, noremap = true }
  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set("n", "g.", function()
    vim.lsp.buf.code_action()
  end, opts)
end

return M
