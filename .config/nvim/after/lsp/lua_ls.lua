local handlers = require("config.lsp.handlers")

---@type vim.lsp.Config
return {
  on_attach = handlers.on_attach,
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and path ~= vim.fs.joinpath(vim.fn.expand("~"), ".dotfiles", ".config", "nvim")
      then
        return
      end

      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          version = "LuaJIT",
          path = {
            "lua/?.lua",
            "lua/?/init.lua",
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
      })
    end
  end,
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      diagnostics = {
        disable = { "missing-fields" },
      },
    },
  },
}
