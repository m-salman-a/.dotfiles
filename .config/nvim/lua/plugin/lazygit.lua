local M = {}

local cmd = "lazygit"
local cmd_name = "LazyGit"

local global_config = {
  window = {
    height_percentage = 0.9,
    width_percentage = 0.95,
  },
}

M.open_lazygit = function()
  local buf = vim.api.nvim_create_buf(false, true)
  if buf == 0 then
    return
  end

  vim.api.nvim_buf_set_name(buf, cmd_name)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"

  local screen_h = vim.o.lines - vim.o.cmdheight - 1
  local height = math.floor(screen_h * global_config.window.height_percentage)
  local width = math.floor(vim.o.columns * global_config.window.width_percentage)
  local row = math.floor((screen_h - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    height = height,
    width = width,
    row = row,
    col = col,
  })
  if win == 0 then
    return
  end

  vim.fn.jobstart({ cmd }, {
    term = true,
    on_exit = function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })

  vim.cmd("startinsert")
end

M.setup = function(config)
  if vim.fn.executable(cmd) == 0 then
    vim.notify(cmd_name .. " not found. Please install it or check your PATH.", vim.log.levels.ERROR)
    return
  end

  if config ~= nil then
    vim.tbl_deep_extend("force", global_config, config)
  end

  vim.api.nvim_create_user_command("LazyGit", M.open_lazygit, { desc = "Toggle LazyGit" })

  vim.keymap.set("n", "<leader>lg", M.open_lazygit, { desc = "[L]azy[G]it", silent = true, noremap = true })
end

return M
