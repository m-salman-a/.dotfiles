local inputs = require("neo-tree.ui.inputs")

-- Trash the target
local function trash(state)
  local node = state.tree:get_node()
  if node.type == "message" then
    return
  end
  local _, name = require("neo-tree.utils").split_path(node.path)
  local msg = string.format("Are you sure you want to trash '%s'?", name)
  inputs.confirm(msg, function(confirmed)
    if not confirmed then
      return
    end
    vim.api.nvim_command("silent !trash " .. node.path)
    require("neo-tree.sources.manager").refresh(state)
  end)
end

-- Trash the selections (visual mode)
local function trash_visual(state, selected_nodes)
  local paths_to_trash = {}
  for _, node in ipairs(selected_nodes) do
    if node.type ~= "message" then
      table.insert(paths_to_trash, node.path)
    end
  end
  local msg = "Are you sure you want to trash " .. #paths_to_trash .. " items?"
  inputs.confirm(msg, function(confirmed)
    if not confirmed then
      return
    end
    for _, path in ipairs(paths_to_trash) do
      vim.api.nvim_command("silent !trash " .. path)
    end
    require("neo-tree.sources.manager").refresh(state)
  end)
end

require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "", -- "" to use 'winborder'
  sources = {
    "filesystem",
    "buffers",
    "document_symbols",
  },
  commands = {
    trash = trash,
    trash_visual = trash_visual,
  },
  window = {
    mappings = {
      ["h"] = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
      ["l"] = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          if not node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
          end
        else
          state.commands.open(state)
        end
      end,
      ["<S-l>"] = "open",
    },
  },
  default_component_configs = {
    modified = {
      symbol = "",
      highlight = "NeoTreeModified",
    },
    git_status = {
      symbols = {
        -- Change type
        added = "✚",
        removed = "✖",
        modified = "",
        renamed = "󰁕",
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },
  renderers = {
    file = {
      { "indent" },
      { "icon" },
      {
        "container",
        content = {
          { "modified", zindex = 10 },
          {
            "name",
            zindex = 10,
          },
          {
            "symlink_target",
            zindex = 10,
            highlight = "NeoTreeSymbolicLinkTarget",
          },
          { "clipboard", zindex = 10 },
          { "bufnr", zindex = 10 },
          { "git_status", zindex = 30, align = "right" },
          { "diagnostics", zindex = 20, align = "right" },
          { "file_size", zindex = 10, align = "right" },
          { "type", zindex = 10, align = "right" },
          { "last_modified", zindex = 10, align = "right" },
          { "created", zindex = 10, align = "right" },
        },
      },
    },
  },
  event_handlers = {
    {
      event = "file_open_requested",
      handler = function()
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    window = {
      mappings = {
        ["d"] = "trash",
        ["v"] = "open_vsplit",
      },
    },
  },
  buffers = {
    -- buffers/init.lua BEFORE_RENDER calls git.status() synchronously (vim.fn.system);
    -- override with no-op to avoid blocking the UI on large repos
    before_render = function(_) end,
    window = {
      mappings = {
        ["d"] = "buffer_delete",
      },
    },
  },
  document_symbols = {
    commands = {
      open = function(state)
        require("neo-tree.sources.document_symbols.commands").open(state)
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
})

require("lsp-file-operations").setup()

vim.keymap.set(
  "n",
  "<leader>e",
  "<Cmd>Neotree toggle reveal<CR>",
  { desc = "File [E]xplorer", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>fb",
  "<Cmd>Neotree toggle buffers<CR>",
  { desc = "[B]uffers", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>so",
  "<Cmd>Neotree document_symbols<CR>",
  { desc = "Document [s]ymb[o]ls", noremap = true, silent = true }
)
