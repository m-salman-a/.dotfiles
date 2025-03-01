local opts = { silent = true }

-- Resize
vim.keymap.set("n", "<M-h>", ":vertical resize -2<cr>", opts)
vim.keymap.set("n", "<M-j>", ":resize +2<cr>", opts)
vim.keymap.set("n", "<M-k>", ":resize -2<cr>", opts)
vim.keymap.set("n", "<M-l>", ":vertical resize +2<cr>", opts)

-- Buffers
vim.keymap.set("n", "<S-l>", ":bnext<cr>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<cr>", opts)

-- Swap lines
vim.keymap.set("x", "<M-j>", ":m'>+<CR>gv=gv", opts)
vim.keymap.set("x", "<M-k>", ":m-2<CR>gv=gv", opts)
