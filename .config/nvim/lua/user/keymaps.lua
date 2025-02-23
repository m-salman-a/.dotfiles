local opts = { noremap = true, silent = true }

-- Copy to clipboard
vim.keymap.set("v", "<C-c>", '"+y', opts)

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<M-j>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<M-k>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Swap lines
-- https://stackoverflow.com/questions/41084565/moving-multiple-lines-in-vim-visual-mode
vim.keymap.set("n", "<M-Up>", ":m-2<CR>==", opts)
vim.keymap.set("n", "<M-Down>", ":m+<CR>==", opts)
vim.keymap.set("x", "<M-Up>", ":m-2<CR>gv=gv", opts)
vim.keymap.set("x", "<M-Down>", ":m'>+<CR>gv=gv", opts)

-- Plugins

vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>", opts)

vim.keymap.set("n", "<Leader>ff", ":Telescope find_files <CR>", opts)
vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep <CR>", opts)
vim.keymap.set("n", "<Leader>fb", ":Telescope buffers initial_mode=normal<CR>", opts)

vim.keymap.set("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })
