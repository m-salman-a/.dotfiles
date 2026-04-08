return {
  {
    "nvim-lualine/lualine.nvim",
    -- enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        component_separators = { left = "|", right = "|" },
        section_separators = { left = " ", right = " " },
      },
      sections = {
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true,
            path = 1,
          },
        },
        lualine_x = {
          "filetype",
          "diagnostics",
        },
        lualine_y = {},
      },
      extensions = { "neo-tree" },
    },
  },
}
