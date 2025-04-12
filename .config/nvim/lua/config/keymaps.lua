local opts = { silent = true, noremap = true }

-- Resize
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<M-j>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<M-k>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Swap lines
vim.keymap.set("x", "<M-j>", ":m'>+<CR>gv=gv", opts)
vim.keymap.set("x", "<M-k>", ":m-2<CR>gv=gv", opts)

-- Source files
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
