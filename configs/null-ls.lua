local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css", "json", "astro" } }, -- so prettier works only on these filetypes
  b.formatting.eslint,

  -- Python
	b.formatting.isort,
	b.formatting.black.with({ extra_args = { "--line-length", "79" } }),

  -- XML
	b.formatting.xmlformat,

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
