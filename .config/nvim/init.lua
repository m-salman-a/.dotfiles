-- TODO:
-- lsp document file operations deprecated
-- show context at statusline
-- keymaps table
-- move lsp color highlight to virtual text
-- FIXME:
-- biome lsp for monorepo setup

vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.winborder = "rounded"
vim.o.foldenable = false
vim.o.scrolloff = 8
vim.o.cursorline = true
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.completeopt = "fuzzy,menu,menuone,popup,noinsert"
vim.o.complete = "o,.,w,b,u,t"
vim.o.updatetime = 50
vim.o.swapfile = false
vim.o.showmode = false -- hide mode from command
vim.o.showcmd = false -- hide selection count from command
vim.o.shortmess = vim.o.shortmess .. "S" -- hide search count from command
vim.o.termguicolors = true

-- Load colorsscheme first
vim.pack.add({
  { src = "https://github.com/navarasu/onedark.nvim" },
})

require("onedark").setup({
  style = "dark",
  colors = {
    red = "#d07277",
  },
  highlights = {
    ["@constructor"] = { fg = "$purple", fmt = "none" },
    ["@tag.tsx"] = { fg = "$yellow" },
    ["@tag.builtin.tsx"] = { fg = "$yellow" },
    ["@tag.delimiter.tsx"] = { fg = "$fg" },
    ["@variable.builtin"] = { fg = "$fg" },
    ["@lsp.type.property"] = { fg = "$red" },
    ["@lsp.type.parameter"] = { fg = "$fg" },
    ["@lsp.type.annotation"] = { fg = "$purple" },
    ["@lsp.mod.annotation"] = { fg = "$purple" },
    ["@lsp.mod.label"] = { fg = "$red" },
    ["@lsp.typemod.variable.defaultLibrary"] = { fg = "$fg" },
    DiagnosticHint = { fg = "$cyan" },
    DiagnosticUnderlineHint = { sp = "$cyan" },
    DiagnosticVirtualTextHint = { fg = "$cyan" },
    LualineModified = { fg = "$blue", bg = "$bg1" },
    NeoTreeDirectoryName = { fg = "$fg" },
    NeoTreeModified = { fg = "$blue" },
    NeoTreeGitUntracked = { fg = "$green", fmt = "none" },
  },
})

vim.cmd([[colorscheme onedark]])

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Plugin update hooks",
  group = vim.api.nvim_create_augroup("plugin-update", { clear = true }),
  callback = function(ev)
    if ev.data.kind == "install" or ev.data.kind == "update" then
      if ev.data.spec.name == "nvim-treesitter" then
        vim.cmd("TSUpdate")
      end

      if ev.data.spec.name == "telescope-fzf-native.nvim" then
        vim.system({ "make" }, { cwd = ev.data.path }):wait()
      end
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1"),
  },
  { src = "https://github.com/nvim-mini/mini.surround" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  {
    src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
    version = vim.version.range("3"),
  },
  { src = "https://github.com/antosha417/nvim-lsp-file-operations" }, -- maybe replace
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
  { src = "https://github.com/nvimtools/none-ls.nvim" },
  { src = "https://github.com/nvimtools/none-ls-extras.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
})

require("mason").setup()

require("nvim-treesitter").install({
  "lua",
  "vimdoc",
  "javascript",
  "typescript",
  "jsx",
  "tsx",
  "dart",
  "python",
  "bash",
  "json",
  "yaml",
})

require("mini.surround").setup()

require("nvim-autopairs").setup({
  enable_check_bracket_line = true,
})

require("nvim-ts-autotag").setup()

require("oil").setup({
  default_file_explorer = false,
  delete_to_trash = true,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      return name:match(".git")
    end,
  },
})

require("gitsigns").setup({
  sign_priority = 100,
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 300,
  },
})

require("todo-comments").setup()

require("treesitter-context").setup({
  enable = false,
})

require("ibl").setup({
  scope = { enabled = false },
})

require("plugin.lazygit").setup()
require("plugin.leaf").setup()
require("plugin.claude").setup()
require("plugin.lsp-highlight").setup()

local lsp_servers = { "lua_ls", "vtsls", "jsonls", "basedpyright", "biome" }
for _, server in ipairs(lsp_servers) do
  vim.lsp.enable(server)
end

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  jump = {
    float = true,
  },
})

vim.keymap.set("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "[S]hift to next buffer", silent = true, noremap = true })
vim.keymap.set(
  "n",
  "<S-h>",
  "<Cmd>bprevious<CR>",
  { desc = "[S]hift to previous buffer", silent = true, noremap = true }
)

vim.keymap.set("n", "<A-k>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<A-j>", ":resize -2<CR>", { silent = true })
vim.keymap.set("n", "<A-h>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<A-l>", ":vertical resize +2<CR>", { silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Start treesitter",
  group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
  end,
})
