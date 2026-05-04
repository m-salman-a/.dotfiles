local M = {}

M.on_attach = function(client, bufnr)
  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end, { desc = "[G]oto [d]efinition", silent = true, noremap = true })
  vim.keymap.set("n", "g.", function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return not action.disabled
      end,
    })
  end, { desc = "[G]et actions", silent = true, noremap = true })
end

return M
