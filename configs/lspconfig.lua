local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "eslint",
  "tsserver",
  "clangd",
  "volar",
  "tailwindcss",
  "yamlls",
  "lemminx",
  "blueprint_ls",
  "astro",
  "swift_mesonls",
  -- "ruff_lsp",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd_env = { VIRTUAL_ENV = "$HOMEl/Desktop/fedora-toolbox-custom-home" },
  }
end

lspconfig.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        ruff = {
          enabled = true,                      -- Enable the plugin
          -- executable = "<path-to-ruff-bin>",   -- Custom path to ruff
          -- path = "<path_to_custom_ruff_toml>", -- Custom config for ruff to use
          extendSelect = { "I" },              -- Rules that are additionally used by ruff
          extendIgnore = { "C90" },            -- Rules that are additionally ignored by ruff
          format = { "I" },                    -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
          severities = { ["D212"] = "I" },     -- Optional table of rules where a custom severity is desired
          unsafeFixes = false,                 -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

          -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
          lineLength = 79,                                 -- Line length to pass to ruff checking and formatting
          exclude = { "__about__.py" },                    -- Files to be excluded by ruff checking
          select = { "F" },                                -- Rules to be enabled by ruff
          ignore = { "D210" },                             -- Rules to be ignored by ruff
          perFileIgnores = { ["__init__.py"] = "CPY001" }, -- Rules that should be ignored for specific files
          preview = false,                                 -- Whether to enable the preview style linting and formatting.
          targetVersion = "py310",                         -- The minimum python version to target (applies for both linting and formatting).
        },
        black = {
          enable = true,
          line_length = 79,
        },
        pycodestyle = {
          enabled = true,
        },
        pyflakes = {
          enabled = false,
        },
        mccabe = {
          enabled = false,
        },
      },
    },
  },
}
-- lspconfig.pylsp.setup {
--   cmd_env = { VIRTUAL_ENV = "$HOMEl/" },
--   settings = {
--     pylsp = {
--       plugins = {
--         -- formatter options
--         black = {
--           enable = true,
--           line_length = 79,
--         },
--         autopep8 = { enabled = false },
--         yapf = { enabled = false },
--         -- linter options
--         pylint = { enabled = false, executable = "pylint", args = { "--max-line-length=79" } }, -- disabled by ruff by default, reenable if remove ruff
--         pyflakes = { enabled = false },
--         pycodestyle = {
--           enable = false,
--           maxLineLength = 79,
--           -- ignore = {'W391'},
--         },
--         -- type checker
--         pylsp_mypy = { enabled = false },
--         -- auto-completion options
--         jedi_completion = { fuzzy = true },
--         -- import sorting
--         pyls_isort = { enabled = false }, -- disabled by ruff by default, reenable if remove ruff
--         ruff = {
--           enabled = true,                 -- Enable the plugin
--           -- executable = "<path-to-ruff-bin>",   -- Custom path to ruff
--           -- path = "<path_to_custom_ruff_toml>", -- Custom config for ruff to use
--           extendSelect = { "I" },          -- Rules that are additionally used by ruff
--           -- extendIgnore = { "C90" },            -- Rules that are additionally ignored by ruff
--           format = { "I" },                -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
--           severities = { ["D212"] = "I" }, -- Optional table of rules where a custom severity is desired
--           unsafeFixes = false,             -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action
--
--           -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
--           lineLength = 88,                                 -- Line length to pass to ruff checking and formatting
--           exclude = { "__about__.py" },                    -- Files to be excluded by ruff checking
--           select = { "F" },                                -- Rules to be enabled by ruff
--           ignore = { "D210" },                             -- Rules to be ignored by ruff
--           perFileIgnores = { ["__init__.py"] = "CPY001" }, -- Rules that should be ignored for specific files
--           preview = true,                                 -- Whether to enable the preview style linting and formatting.
--           targetVersion = "py310",                         -- The minimum python version to target (applies for both linting and formatting).
--         },
--       },
--     },
--   },
-- }
--
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- local signs = { Error = "○ ", Warn = "○ ", Hint = "○ ", Info = "○ " }
local signs = { Error = "🤬", Warn = "🖐️", Hint = "☝️", Info = "🤓" }
-- local signs = { Error = " ", Warn = "󰗖 ", Hint = "󰦤 ", Info = "󰵛 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Show line diagnostics automatically in hover window
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic_cursor", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end,
})

-- Go-to definition in a split window
local function goto_definition(split_cmd)
  local util = vim.lsp.util
  local log = require "vim.lsp.log"
  local api = vim.api

  local handler = function(_, result, ctx)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, "No location found")
      return nil
    end

    if split_cmd then
      vim.cmd(split_cmd)
    end

    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])

      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command "copen"
        api.nvim_command "wincmd p"
      end
    else
      util.jump_to_location(result)
    end
  end

  return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition "vsplit"
