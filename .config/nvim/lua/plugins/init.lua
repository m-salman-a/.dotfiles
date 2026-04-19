return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme catppuccin-frappe]])
    end,
  },

  {
    "https://github.com/navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark",
      })
      require("onedark").load()
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  {
    "nvim-mini/mini.pairs",
    version = "*",
    opts = {},
  },

  {
    "nvim-mini/mini.surround",
    version = "*",
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
