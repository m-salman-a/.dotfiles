local telescope = require("telescope")
local builtin = require("telescope.builtin")
local config = require("telescope.config")
local actions = require("telescope.actions")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
    preview = {
      filesize_limit = 0.1, -- MB
    },
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      preview = false,
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    git_branches = {
      theme = "dropdown",
      preview = false,
    },
  },
})

telescope.load_extension("fzf")

vim.keymap.set("n", "<leader>p", builtin.find_files, { desc = "Find in [p]roject", silent = true, noremap = true })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [g]rep", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "[G]it [b]ranch", silent = true, noremap = true })
