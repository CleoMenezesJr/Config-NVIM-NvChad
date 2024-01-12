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
  "swift_mesonls"
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd_env = { VIRTUAL_ENV = "$HOMEl/Desktop/fedora-toolbox-custom-home" },
  }
end

lspconfig.pylsp.setup {
  cmd_env = { VIRTUAL_ENV = "$HOMEl/" },
  settings = {
    pylsp = {
      plugins = {
        -- formatter options
        black = {
          enable = true,
          line_length = 88,
        },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        -- linter options
        pylint = { enabled = true, executable = "pylint", args = { "--max-line-length=88" } },
        pyflakes = { enabled = false },
        pycodestyle = {
          enable = false,
          maxLineLength = 88,
          -- ignore = {'W391'},
        },
        -- type checker
        pylsp_mypy = { enabled = false },
        -- auto-completion options
        jedi_completion = { fuzzy = true },
        -- import sorting
        pyls_isort = { enabled = true },
      },
    },
  },
}

-- lspconfig.pyright.setup { blabla}

vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- local signs = { Error = "○ ", Warn = "○ ", Hint = "○ ", Info = "○ " }
-- local signs = { Error = "🤬", Warn = "🖐️", Hint = "☝️", Info = "🤓" }
local signs = { Error = " ", Warn = "󰗖 ", Hint = "󰦤 ", Info = "󰵛 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Show line diagnostics automatically in hover window
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic_cursor", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
  end
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
