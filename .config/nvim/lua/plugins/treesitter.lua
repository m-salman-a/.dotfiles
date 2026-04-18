return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserConfig", { clear = true }),
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if not ok then
            return
          end
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
        end,
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  {
    "folke/ts-comments.nvim",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
    opts = {},
    event = "VeryLazy",
  },
}
