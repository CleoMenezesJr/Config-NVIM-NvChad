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
  local conf = require "plugins.configs.nvimtree"
  conf.renderer.full_name = true
  conf.renderer.highlight_git = true
  conf.git = {
    enable = true,
    ignore = false,
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

  return conf
end

return M
