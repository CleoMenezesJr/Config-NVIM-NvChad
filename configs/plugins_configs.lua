M = {}

M.ufo = {
  init = function()
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.foldmethod = "indent"
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

    -- Ignore filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "nvdash" },
      callback = function()
        require("ufo").detach()
        vim.opt_local.foldenable = false
        -- vim.wo.foldcolumn = "0"
      end,
    })
  end,
  opts = function(_, opts)
    opts.preview = {
      win_config = {
        border = "rounded",
        winhighlight = "Normal:Folded",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    }
    require("custom.configs.custom_scripts").custom_select_n_virt_text_fold(opts)
  end,

  keys = {
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
      desc = "Open all folds",
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
      desc = "Close all folds",
    },
    {
      "K",
      function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
    },
  },
}

M.sessionmanager = {
  init = function()
    -- Open Nvimtree on init project
    -- local config_group = vim.api.nvim_create_augroup("MyConfigGroup", {}) -- A global group for all your config autocommands
    -- vim.api.nvim_create_autocmd({ "User" }, {
    --   pattern = "SessionLoadPre",
    --   group = config_group,
    --   callback = function()
    --     require("nvim-tree.api").tree.open()
    --   end,
    -- })

    -- Go to root's project directory
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.cmd "SessionManager load_session"
      end,
    })
    vim.cmd "cd%:p:h"
  end,

  config = function()
    local Path = require "plenary.path"
    require("session_manager").setup {
      -- autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
      autoload_mode = false,
      sessions_dir = Path:new(vim.fn.stdpath "data", "sessions"), -- The directory where the session files will be saved.
      max_path_length = 50,
      autosave_ignore_dirs = {
        "/",
        "~",
        "~\\Documents\\Projects",
      },
      autosave_ignore_filetypes = {
        "gitcommit",
        -- "toggleterm",
      },
    }
    -- Auto save session
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          -- Don't save while there's any 'nofile' buffer open.
          if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
            return
          end
        end
        vim.cmd "SessionManager save_current_session"
      end,
    })
    -- vim.keymap.set("n", "<leader>sx", "<cmd>cd ~|%bd|Alpha<cr>", { desc = "Clear session" })
  end,
}

M.minisurround = {
  opts = {
    mappings = {
      add = "<leader>sa",
      delete = "<leader>sd",
      find = "<leader>sf",
      find_left = "<leader>sF",
      highlight = "<leader>sh",
      replace = "<leader>sr",
      update_n_lines = "<leader>sn",
    },
  },
}

return M
