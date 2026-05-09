local M = {}

local global_config = {
  window = {
    width_percentage = 0.35,
  },
}

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
    width = math.ceil(vim.o.columns * global_config.window.width_percentage),
    style = "minimal",
    win = last_win,
  })

  vim.wo[win].winhighlight = "Normal:Normal,NormalNC:NormalNC"

  buffer_window_map[buf] = win

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

  open_win(buf)

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

local function get_normal_wins(tabpage)
  local normal_wins = {}
  local wins = vim.api.nvim_tabpage_list_wins(tabpage)

  for _, win in ipairs(wins) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == "" then
      table.insert(normal_wins, win)
    end
  end

  return normal_wins
end

local is_all_claude_windows = function(excluded)
  local loaded_windows = get_normal_wins(0)
  local claude_windows = vim.tbl_values(buffer_window_map)

  for i, v in ipairs(loaded_windows) do
    if v == excluded then
      table.remove(loaded_windows, i)
      break
    end
  end

  if #claude_windows == 0 or #loaded_windows ~= #claude_windows then
    return false
  end

  return vim.deep_equal(loaded_windows, claude_windows)
end

M.check_claude_windows_remaining = function()
  vim.api.nvim_create_autocmd("WinClosed", {
    group = vim.api.nvim_create_augroup("check_claude_windows_remaining", { clear = true }),
    callback = function(args)
      local excluded = tonumber(args.file)

      if not is_all_claude_windows(excluded) then
        return
      end

      local buf = vim.api.nvim_create_buf(true, false)

      vim.api.nvim_open_win(buf, true, {
        split = "left",
        width = vim.o.columns - math.ceil(vim.o.columns * global_config.window.width_percentage),
      })
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
        vim.api.nvim_win_hide(win)
      end
      buffer_window_map[buf] = -1
    end
  else
    for buf, _ in pairs(buffer_window_map) do
      open_win(buf)
    end
  end

  windows_visible = not windows_visible
end

M.setup = function(config)
  if config ~= nil then
    global_config = config
  end

  vim.keymap.set("n", "<leader>an", M.open_claude, { desc = "[A]i [n]ew", silent = true, noremap = true })
  vim.keymap.set("n", "<leader>ai", M.toggle_claude, { desc = "[A][i]", silent = true, noremap = true })

  M.check_claude_windows_remaining()
end

return M
