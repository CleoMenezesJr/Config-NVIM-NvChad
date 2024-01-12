---@type MappingsTable
local M = {}

M.general = {
  n = {
    ["<leader>tN"] = { "<cmd> tabnew <CR>", opts = { nowait = true } },
    ["<leader>tn"] = { "<cmd> tabNext <CR>", opts = { nowait = true } },
    ["<leader>tc"] = { "<cmd> tabclose <CR>", opts = { nowait = true } },
    -- ["<leader>e"] = { "<cmd> Telescope file_browser path=%:p:h select_buffer=true<CR>", opts = { nowait = true } },
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", opts = { nowait = true } },
    ["<leader>tgc"] = {
      "<cmd> Telescope conventional_commits theme=dropdown include_body_and_footer=true <CR>",
      opts = { nowait = true },
    },
    ["<leader><tab>"] = {
      "<cmd> Telescope buffers theme=dropdown <CR>",
      opts = { nowait = true },
    },
    ["<leader>sls"] = {
      function()
        require("session_manager").load_session()
      end,
      "Load Session",
      opts = { nowait = true },
    },
    ["<leader>sll"] = {
      function()
        require("session_manager").load_session()
      end,
      "Load Session",
      opts = { nowait = true },
    },
    ["<leader>fra"] = {
      function()
        require("custom.configs.custom_scripts").find_and_replace_all "g"
      end,
      "Find and Replace All",
      opts = { nowait = true },
    },
    ["<leader>fri"] = {
      function()
        require("custom.configs.custom_scripts").find_and_replace_all "gc"
      end,
      "Find and Replace All (Interactive)",
      opts = { nowait = true },
    },
    -- ["<leader>fr"] = { , "Load Session", opts = { nowait = true } },
  },
  t = {
    ["<esc>"] = { "<c-\\><c-n>", opts = { nowait = true } },
  },
}

-- more keybinds!

return M
