return {
  {
    "nvim-mini/mini.surround",
    version = "*",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "<filetype>" },
        callback = function()
          vim.treesitter.start()
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
        end,
      })
    end,
  },
}
