local opts = { noremap = true, silent = true }

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
