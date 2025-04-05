-- theme.lua
-- Custom theme overrides for Gruvbox + plugin-specific highlight tweaks

local M = {}

function M.setup()
  vim.cmd.colorscheme("gruvbox")

  local colors = require("gruvbox").palette

  -- LSP reference highlights (bold + gruvbox colors, no background)
  vim.api.nvim_set_hl(0, "LspReferenceText", { fg = colors.yellow, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = colors.aqua, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = colors.orange, bold = true, bg = "NONE" })

  -- Diagnostic sign column background cleanup
  vim.api.nvim_set_hl(0, "SignColumn", { bg = colors.bg0 })
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = colors.bg0 })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = colors.bg0 })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = colors.bg0 })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = colors.bg0 })

  -- NvimTree tweaks to match Gruvbox
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = colors.bg0, fg = colors.fg1 })
  vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = colors.bg0, fg = colors.fg1 })
  vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = colors.bg0, fg = colors.bg1 })
  vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = colors.green, bold = true })
  vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = colors.yellow, bold = true })
  vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = colors.gray, italic = true })

  vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = colors.green })
  vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = colors.red })
  vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { fg = colors.blue })
  vim.api.nvim_set_hl(0, "NvimTreeGitMerge", { fg = colors.orange })

  vim.api.nvim_set_hl(0, "NvimTreeSymlink", { fg = colors.purple, italic = true })
  vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = colors.aqua, bold = true })
end

return M
