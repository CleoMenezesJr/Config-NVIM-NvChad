local overrides = require "custom.configs.overrides"
local plugins_configs = require "custom.configs.plugins_configs"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  -- Override the whole comment nvim plugin. make it better later
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n",          desc = "Comment toggle current line" },
      { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n",          desc = "Comment toggle current block" },
      { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("ts_context_commentstring").setup {
            enable_autocmd = false,
            languages = {
              astro = "<!-- %s -->",
              blueprint = "// %s",
            },
          }
        end,
      },
      "windwp/nvim-ts-autotag",
    },
    opts = overrides.treesitter(),
  },

  -- To make a plugin not be loaded
  {
    "NvChad/nvim-colorizer.lua",
    enabled = true,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      overrides.gitsigns()
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    -- enabled = false,
    opts = function()
      overrides.nvimtree()
    end,
  },

  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      plugins_configs.sessionmanager.init()
    end,
    lazy = false,
    config = function()
      plugins_configs.sessionmanager.config()
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    event = "BufRead",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    init = function()
      plugins_configs.ufo.init()
    end,
    opts = function(_, opts)
      plugins_configs.ufo.opts(_, opts)
    end,
    keys = plugins_configs.ufo.keys,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "BufRead",
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        relculright = true,
        segments = {
          -- { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
          {
            sign = { name = { ".*" }, maxwidth = 1, colwidth = 2, auto = false, wrap = false },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc, "" }, click = "v:lua.ScLa" },
          {
            -- sign = { name = { ".*" }, namespace = { "gitsigns" }, colwidth = 1, fillchar = "▏" },
            sign = { name = { ".*" }, namespace = { "gitsigns" }, colwidth = 1 },
            click = "v:lua.ScSa",
          },
        },
      }
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "olacin/telescope-cc.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    init = function()
      require("core.utils").load_mappings "telescope"
      -- load extensions
      local telescope = require "telescope"
      local extensions_list = { "ui-select", "file_browser", "conventional_commits" }
      for _, ext in ipairs(extensions_list) do
        telescope.load_extension(ext)
      end
    end,
    opts = function()
      overrides.telescope.opts()
    end,
  },

  {
    "danymat/neogen",
    lazy = false,
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    "echasnovski/mini.surround",
    keys = function(plugin, keys)
      -- Populate the keys based on the user's options
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add,            desc = "Add surrounding",                     mode = { "n", "v" } },
        { opts.mappings.delete,         desc = "Delete surrounding" },
        { opts.mappings.find,           desc = "Find right surrounding" },
        { opts.mappings.find_left,      desc = "Find left surrounding" },
        { opts.mappings.highlight,      desc = "Highlight surrounding" },
        { opts.mappings.replace,        desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = plugins_configs.minisurround.opts,
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
  -- {
  --   "nvimdev/lspsaga.nvim",
  --   event = "LspAttach",
  --   opts = {
  --     code_action = {
  --       show_server_name = false,
  --       num_shortcut = false,
  --     },
  --     request_timeout = 2000,
  --     lightbulb = {
  --       enable = true,
  --       enable_in_insert = true,
  --       sign = true,
  --       sign_priority = 40,
  --       virtual_text = false,
  --     },
  --     diagnostic = {
  --       show_code_action = true,
  --     },
  --     symbol_in_winbar = {
  --       enable = true,
  --       separator = " ",
  --       hide_keyword = true,
  --       show_file = true,
  --       folder_level = 2,
  --       respect_root = false,
  --       color_mode = true,
  --     },
  --     ui = {
  --       title = false,
  --       expand = "",
  --       collapse = "",
  --       code_action = "",
  --     },
  --   },
  -- },
}

return plugins
