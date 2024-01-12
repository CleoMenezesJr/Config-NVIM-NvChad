local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Use native folder config
--
-- local opt = vim.opt
-- local o = vim.o
--
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- -- opt.foldtext = "v:lua.vim.treesitter.foldtext()"
-- -- o.foldcolumn = '1'
-- o.foldlevel = 99
-- o.foldlevelstart = 99
-- o.foldenable = true

vim.opt.shell = "bash"
vim.opt.tabline = ""
vim.cmd [[ set showtabline=0 ]]
-- vim.opt.numberwidth = 3
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
