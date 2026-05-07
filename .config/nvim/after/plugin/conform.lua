local js_formatters = { "biome-check", "prettierd", stop_after_first = true }

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = js_formatters,
    typescript = js_formatters,
    javascriptreact = js_formatters,
    typescriptreact = js_formatters,
    json = js_formatters,
    dart = { lsp_format = true },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 1000 }
  end,
})

vim.g.disable_autoformat = false

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})
