local opts = { silent = true }

-- Resize
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<M-j>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<M-k>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Swap lines
vim.keymap.set("n", "<M-Up>", ":m-2<CR>==", opts)
vim.keymap.set("n", "<M-Down>", ":m+<CR>==", opts)
vim.keymap.set("x", "<M-Up>", ":m-2<CR>gv=gv", opts)
vim.keymap.set("x", "<M-Down>", ":m'>+<CR>gv=gv", opts)

-- Open diagnostics float
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "[D]iagnostic Float" })
