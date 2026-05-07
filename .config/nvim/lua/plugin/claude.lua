local M = {}

---@type boolean
local windows_visible = true

---@type table<number, number>
local buffer_window_map = {}

local open_win = function(buf)
  local last_win = nil
  for _, win in pairs(buffer_window_map) do
    last_win = win
  end

  local win = vim.api.nvim_open_win(buf, true, {
    split = "right",
    width = math.ceil(vim.o.columns * 0.35),
    style = "minimal",
    win = last_win,
  })
  vim.wo[win].winhighlight = "Normal:Normal,NormalNC:NormalNC"
  return win
end

M.open_claude = function()
  local cmd = "claude"
  if vim.fn.executable(cmd) == 0 then
    vim.notify("Claude CLI not found. Please install it or check your PATH.", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "Claude Code")

  local win = open_win(buf)

  buffer_window_map[buf] = win

  vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    buf = buf,
    callback = function()
      vim.cmd("startinsert")
    end,
  })

  ---@type vim.keymap.set.Opts
  local opts = { silent = true, noremap = true, buf = buf }
  vim.keymap.set("t", "<C-w>n", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-w>h", [[<C-\><C-n><C-w>h]], opts)
  vim.keymap.set("t", "<C-w>j", [[<C-\><C-n><C-w>j]], opts)
  vim.keymap.set("t", "<C-w>k", [[<C-\><C-n><C-w>k]], opts)
  vim.keymap.set("t", "<C-w>l", [[<C-\><C-n><C-w>l]], opts)

  vim.fn.jobstart(cmd, {
    term = true,
    env = { CLAUDECODE = "1" },
    on_exit = function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
      buffer_window_map[buf] = nil
    end,
  })
end

M.toggle_claude = function()
  if vim.tbl_count(buffer_window_map) == 0 then
    M.open_claude()
    windows_visible = true
    return
  end

  if windows_visible then
    for buf, win in pairs(buffer_window_map) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      buffer_window_map[buf] = -1
    end
  else
    for buf, _ in pairs(buffer_window_map) do
      buffer_window_map[buf] = open_win(buf)
    end
  end

  windows_visible = not windows_visible
end

M.setup = function()
  vim.keymap.set("n", "<leader>an", M.open_claude, { desc = "[A]i [n]ew", silent = true, noremap = true })
  vim.keymap.set("n", "<leader>ai", M.toggle_claude, { desc = "[A][i]", silent = true, noremap = true })
end

return M
