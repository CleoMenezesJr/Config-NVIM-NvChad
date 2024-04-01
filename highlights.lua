-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = { italic = true },
  -- IndentBlanklineContextStart = { bg = "statusline_bg" },
  IndentBlanklineContextStart = { bg = "one_bg" },
  Visual = { bg = "one_bg3" },
  -- DiagnosticError = { italic = true },
  -- DiagnosticWarn = { italic = true },
  -- DiagnosticInformation = { italic = true },
  -- DiagnosticHint = { italic = true },
  FoldColumn = { bg = "black", fg = "grey" },
  CursorLine = { bg = "black2" },
  Folded = {bg = "darker_black"}
}

---@type HLTable
Msladd = {
  -- NvimTreeOpenedFolderName = { fg = "green", bold = true },
  UfoCursorFoldedLine = { bg = "black2" },
  -- DiagnosticUnderlineOk = { undercurl = true },
  -- DiagnosticUnderlineHint = { undercurl = true },
  -- DiagnosticUnderlineError = { undercurl = true },
  -- DiagnosticUnderlineInfo = { undercurl = true },
  -- DiagnosticUnderlineWarn = { undercurl = true },
}

return M
