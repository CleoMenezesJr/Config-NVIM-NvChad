-- Former overrides.lua
M = {}

M.telescope = {
  opts = function()
    local conf = require "plugins.configs.telescope"

    local extensions_list = { "ui-select", "file_browser", "conventional_commits" }
    for _, extension in ipairs(extensions_list) do
      table.insert(conf.extensions_list, extension)
    end

    local extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {},
      },
      file_browser = {
        theme = "dropdown",
        hijack_netrw = true,
        initial_mode = "normal",
      },
    }

    conf.extensions = {}
    for key, value in pairs(extensions) do
      conf.extensions[key] = value
    end

    local actions = require "telescope.actions"
    conf.pickers = {
      buffers = {
        initial_mode = "normal",
        previewer = false,

        entry_maker = require("custom.configs.telescope_buffer_style").gen_from_buffer_like_leaderf(),
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer,
          },
          n = {
            ["<c-d>"] = actions.delete_buffer,
          },
        },
      },
    }

    return conf
  end,
}

M.nvimtree = function()
  local HEIGHT_RATIO = 0.4
  local WIDTH_RATIO = 0.4
  local conf = require "plugins.configs.nvimtree"
  conf.view = {
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
        return {
          border = "rounded",
          relative = "editor",
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    },
    width = function()
      return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
    end,
  }

  return conf
end

M.gitsigns = function()
  local conf = require "plugins.configs.others"
  conf.gitsigns.signs.delete = {
    text = "‐",
  }

  return conf
end

M.treesitter = function()
  local conf = require "plugins.configs.treesitter"
  conf.ensure_installed = "all"
  conf.autotag = {
    enable = true,
  }
  conf.context_commentstring = {
    enable = true,
    config = {
      astro = "<!-- %s -->",
      blueprint = "// %s",
    },
  }

  return conf
end

return M
