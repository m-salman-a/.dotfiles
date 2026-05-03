local config = require("config.lsp")

---@type vim.lsp.Config
return {
  on_attach = config.on_attach,
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        preloadFileSize = 10000,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
