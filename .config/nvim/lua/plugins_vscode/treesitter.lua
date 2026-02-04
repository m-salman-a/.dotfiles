return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
        },
      })
    end
  }
}
