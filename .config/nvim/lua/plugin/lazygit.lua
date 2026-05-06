local M = {}

M.open_lazygit = function()
  local cmd = "lazygit"
  if vim.fn.executable(cmd) == 0 then
    vim.notify("LazyGit not found. Please install it or check your PATH.", vim.log.levels.ERROR)
    return
  end

  local screen_h = vim.o.lines - vim.o.cmdheight - 1
  local height = math.floor(screen_h * 0.9)
  local width = math.floor(vim.o.columns * 0.95)
  local row = math.floor((screen_h - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_name(buf, "LazyGit")

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    height = height,
    width = width,
    row = row,
    col = col,
    style = "minimal",
  })

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })

  vim.cmd("startinsert")
end

M.setup = function()
  vim.keymap.set("n", "<leader>lg", M.open_lazygit, { desc = "[L]azy[G]it", silent = true, noremap = true })
end

return M
