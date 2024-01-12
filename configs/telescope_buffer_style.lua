local M = {}

local devicons = require "nvim-web-devicons"
local entry_display = require "telescope.pickers.entry_display"

function M.gen_from_buffer_like_leaderf(opts)
  opts = opts or {}
  local default_icons, _ = devicons.get_icon("file", "", { default = true })

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = vim.fn.strwidth(default_icons) },
      { width = 30 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.devicons, entry.devicons_highlight },
      entry.file_name,
      { vim.fn.fnamemodify(entry.dir_name, ":.") .. "/", "Comment" },
    }
  end

  return function(entry)
    local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
    local hidden = entry.info.hidden == 1 and "h" or "a"
    local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
    local changed = entry.info.changed == 1 and "+" or " "
    local indicator = entry.flag .. hidden .. readonly .. changed

    local dir_name = vim.fn.fnamemodify(bufname, ":p:h:.")
    local file_name = vim.fn.fnamemodify(bufname, ":p:t")

    local icons, highlight = devicons.get_icon(bufname, string.match(bufname, "%a+$"), { default = true })

    return {
      valid = true,

      value = bufname,
      ordinal = entry.bufnr .. " : " .. file_name,
      display = make_display,

      bufnr = entry.bufnr,

      lnum = entry.info.lnum ~= 0 and entry.info.lnum or 1,
      indicator = indicator,
      devicons = icons,
      devicons_highlight = highlight,

      file_name = file_name,
      dir_name = dir_name,
    }
  end
end

return M
