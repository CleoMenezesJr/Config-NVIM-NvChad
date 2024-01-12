---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "vscode_dark",
  -- transparency = true,
  theme_toggle = { "vscode_dark", "vscode_dark" },

  hl_override = highlights.override,
  hl_add = highlights.add,
  tabufline = {
    enabled = false,
    -- Remove it if nvimtree is on the left again
    overriden_modules = function(modules)
      -- table.insert(modules, modules[1])
      table.remove(modules, 1)
      vim.cmd [[ set showtabline=0 ]]
    end,
  },

  statusline = {
    theme = "default",
    overriden_modules = function(modules)
      table.insert(
        modules,
        4,
        (function()
          if vim.bo[vim.fn.bufnr()].modified then
            return "%#St_lspWarning#" .. "  󱙃 Unsaved"
          end
        end)()
      )
      table.insert(
        modules,
         12,
        (function()
          local result, number_of_tabs = "", vim.fn.tabpagenr "$"

          if number_of_tabs > 1 then
            for i = 1, number_of_tabs, 1 do
              local tab_hl = ((i == vim.fn.tabpagenr()) and "%#TbLineTabOn# ") or "%#TbLineTabOff# "
              result = result .. ("%" .. i .. "@TbGotoTab@" .. tab_hl .. i .. " ")
              result = (i == vim.fn.tabpagenr() and  result ) or result
            end

            local tabstoggleBtn = "%@TbToggleTabs@ %#TBTabTitle# Tabs %X"

            return vim.g.TbTabsToggled == 1 and tabstoggleBtn:gsub("()", { [36] = " " })
              or tabstoggleBtn .. result .. "%#St_file_sep#"
          end
        end)()
      )
    end,
  },
  nvdash = {
    load_on_startup = false,

    buttons = {
      { "  Projects", "Spc sls", "SessionManager load_session" },
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
