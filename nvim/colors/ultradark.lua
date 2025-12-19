-- Clear existing highlights
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "ultradark"

local colors = {
  bg        = "#000000",
  fg        = "#FFFFFF",
  red       = "#F07178",
  green     = "#C3E88D",
  yellow    = "#FFCB6B",
  blue      = "#82AAFF",
  magenta   = "#C792EA",
  cyan      = "#89DDFF",
  selection = "#222222",
  grey      = "#333333",
}

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- UI
hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("Visual", { bg = colors.selection })
hl("Cursor", { fg = colors.bg, bg = colors.fg })
hl("LineNr", { fg = colors.grey })

-- Syntax
hl("Comment", { fg = colors.grey, italic = true })
hl("Constant", { fg = colors.cyan })
hl("String", { fg = colors.green })
hl("Identifier", { fg = colors.red })
hl("Function", { fg = colors.blue })
hl("Statement", { fg = colors.magenta })
hl("PreProc", { fg = colors.yellow })
hl("Type", { fg = colors.yellow })
hl("Special", { fg = colors.cyan })

-- Terminal colors for :terminal
vim.g.terminal_color_0 = "#000000"
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.magenta
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = "#CCCCCC"
