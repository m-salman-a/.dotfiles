local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspHighlight", { clear = true }),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      -- Verify if the active language server supports document highlighting
      if not client or not client:supports_method("textDocument/documentHighlight") then
        return
      end

      local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
      vim.api.nvim_clear_autocmds({ buffer = ev.buf, group = group })

      -- Highlight references when the cursor stops moving
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        buffer = ev.buf,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })

      -- Clear highlights immediately when the cursor moves
      vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        buffer = ev.buf,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end,
  })
end

return M
