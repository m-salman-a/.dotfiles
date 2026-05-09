local M = {}

local cmd = "leaf"
local cmd_name = "Leaf"

local global_config = {
  watch = {
    window = {
      width_percentage = nil,
    },
  },
  toggle = {
    window = {
      height_percentage = 0.9,
      width_percentage = 0.95,
    },
  },
}

local global_state = {
  watch = {
    buffer = -1,
  },
}

M.toggle = function(md_buffer)
  local buf = vim.api.nvim_create_buf(false, true)
  if buf == 0 then
    return
  end

  vim.api.nvim_buf_set_name(buf, "Leaf")
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"

  local screen_h = vim.o.lines - vim.o.cmdheight - 1
  local height = math.floor(screen_h * global_config.toggle.window.height_percentage)
  local width = math.floor(vim.o.columns * global_config.toggle.window.width_percentage)
  local row = math.floor((screen_h - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    height = height,
    width = width,
    row = row,
    col = col,
  })

  local file_name = vim.api.nvim_buf_get_name(md_buffer)

  vim.fn.jobstart({ cmd .. " -e nvim " .. file_name }, {
    term = true,
    on_exit = function(_)
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })

  vim.cmd("startinsert")
end

local cleanup_watch_buf = function(buf)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  global_state.watch.buffer = -1
end

local open_watch_win = function(md_buffer, buf)
  local width = nil
  if global_config.watch.window.width_percentage then
    width = math.floor(vim.o.columns * global_config.watch.window.width_percentage)
  end

  local win = vim.api.nvim_open_win(buf, true, {
    split = "right",
    style = "minimal",
    width = width,
  })
  if win == 0 then
    cleanup_watch_buf(buf)
    return
  end

  local file_name = vim.api.nvim_buf_get_name(md_buffer)

  vim.fn.jobstart({ cmd .. " -e nvim -w " .. file_name }, {
    term = true,
    on_exit = function(_)
      cleanup_watch_buf(buf)
    end,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function()
      cleanup_watch_buf(buf)
    end,
    buf = buf,
  })

  local wins = vim.fn.win_findbuf(md_buffer)
  if #wins > 0 then
    vim.api.nvim_set_current_win(wins[1])
    vim.api.nvim_set_current_buf(md_buffer)
  end
end

M.toggle_watch = function(md_buffer)
  local prev_buf = global_state.watch.buffer
  if vim.api.nvim_buf_is_valid(prev_buf) then
    vim.api.nvim_buf_delete(prev_buf, { force = true })
    global_state.watch.buffer = -1
    return
  end

  local buf = vim.api.nvim_create_buf(true, true)
  if buf == 0 then
    return
  end

  global_state.watch.buffer = buf

  vim.api.nvim_buf_set_name(buf, "Leaf")
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"

  open_watch_win(md_buffer, buf)
end

M.toggle_current_buf = function()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Current file is not a markdown file.", vim.log.levels.ERROR)
    return
  end

  M.toggle(vim.api.nvim_get_current_buf())
end

M.toggle_watch_current_buf = function()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Current file is not a markdown file.", vim.log.levels.ERROR)
    return
  end

  M.toggle_watch(vim.api.nvim_get_current_buf())
end

M.setup = function(config)
  if vim.fn.executable(cmd) == 0 then
    vim.notify(cmd_name .. " not found. Please install it or check your PATH.", vim.log.levels.ERROR)
    return
  end

  if config ~= nil then
    vim.tbl_deep_extend("force", global_config, config)
  end

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    group = vim.api.nvim_create_augroup("leaf_markdown_enter", { clear = true }),
    callback = function(args)
      vim.keymap.set("n", "<leader>md", function()
        M.toggle(args.buf)
      end, {
        desc = "[M]ark[d]own",
        buf = args.buf,
        silent = true,
        noremap = true,
      })

      vim.keymap.set("n", "<leader>mw", function()
        M.toggle_watch(args.buf)
      end, {
        desc = "[M]arkdown [w]atch",
        buf = args.buf,
        silent = true,
        noremap = true,
      })
    end,
  })

  vim.api.nvim_create_user_command("LeafView", M.toggle_current_buf, { desc = "View Markdown" })
  vim.api.nvim_create_user_command("LeafWatchToggle", M.toggle_watch_current_buf, { desc = "Watch Markdown" })
end

return M
