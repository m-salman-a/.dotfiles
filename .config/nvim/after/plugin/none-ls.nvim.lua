local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    require("none-ls.diagnostics.eslint").with({
      condition = function(utils)
        return utils.root_has_file({ ".eslintrc.js" })
      end,
    }), -- requires none-ls-extras.nvim
  },
})
