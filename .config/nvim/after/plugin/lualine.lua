---@diagnostic disable-next-line: unused-function, unused-local
local format_branch = function(str)
  if str == "" then
    return ""
  end

  local t = {}
  for m in string.gmatch(str, "([^/]+)") do
    table.insert(t, m)
  end
  return t[#t]
end

require("lualine").setup({
  options = { section_separators = " ", component_separators = " " },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          if str == "" then
            return ""
          end
          local t = {}
          for m in string.gmatch(str, "([^-]+)") do
            table.insert(t, m:sub(1, 1))
          end
          return table.concat(t, "")
        end,
      },
    },
    lualine_b = {},
    lualine_c = {
      {
        function()
          return ""
        end,
        cond = function()
          return vim.api.nvim_get_option_value("modified", { buf = 0 })
        end,
        padding = { right = 1 },
        color = "LualineModified",
      },
      {
        "filename",
        path = 1,
        padding = 0,
        file_status = false,
      },
      {
        "diagnostics",
        padding = 0,
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = " ",
        },
      },
    },
    lualine_x = {
      { "location", padding = 0 },
      {
        "selectioncount",
        padding = 0,
        fmt = function(str)
          if str == "" then
            return str
          end

          return "(" .. str .. ")"
        end,
      },
      {
        "searchcount",
        padding = 0,
      },
    },
    lualine_y = {
      {
        "filetype",
        icons_enabled = false,
        fmt = function(str)
          if str == "typescriptreact" then
            return "tsx"
          end
          if str == "javacriptreact" then
            return "jsx"
          end
          return str
        end,
      },
    },
    lualine_z = {},
  },
  extensions = { "neo-tree", "oil" },
})
